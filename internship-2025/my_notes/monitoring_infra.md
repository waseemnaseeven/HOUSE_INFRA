# Monitoring infrastructure

- Il existe plusieurs type de supervision :
    - Infrastructure Monitoring
        - Server Monitoring (CPU, Memoire, Stockage, Reseau, DB)
    - Network Monitoring
        - check les connexions entre differents ordinateurs, 
        - check traffic in et out 
    - Cost Monitoring
        - Tracker les ressources utilises par rapport a leur cout
    - App Monitoring
        - check si ca run smoooooothly
    - Log Monitoring
        - identifier les erreurs, problemes potentiels

# Metrics

- *Definition*: 
    - Mesure quantifiable permettant de connaitre la distance entre deux points. Ici, on cherchera a savoir la difference entre un comportement habituel et anormal, sur des valeurs comme : CPU, Memoire, Stockage. On parle bcp de sante du systeme, divers aspect de performance....

## Node_exporter

Sur chaque machine est installe un node_exporter qui expose les metriques systemes et reseau, sur le port 9100 (par defaut). Ces metriques sont collectees dans differents fichiers system, souvent dans les dossiers `/sys/`, `/proc` ... 
Il existe une liste de collectors desactive par defaut (par ex: cgroups, network_route, processes, systemd...) pour differentes causes :  haute cardinalite (grande quantite de valeur avec un faible nb de repetitions), temps d'execution plus long, trop grandes ressources demandees.

- Les metriques que nous recoltons sont les suivantes : 
    - Charge sur le CPU
    - Memoire
    - Stockage
    - Bande passante
    - Température
    - Kernel version
    - Systemd

- Passage en revue et explication des differentes metriques analysees : 
    - CPU:
        - `node_cpu_seconds_totals` : le nombre cumulé de secondes durant lesquelles le CPU a été occupé en mode ... (utilisateur systeme, inactif idle, attente I/O iowait, etc.) sur chaque coeur. 
            - Le mode "steal" est utilisé dans les environnements virtualisés et représente le temps pendant lequel le CPU n'est pas disponible pour une machine virtuelle parce qu'il est utilisé par l'hyperviseur (l'host) pour exécuter d'autres tâches ou pour d'autres VMs.
            - Le mode "idle" = temps d'inactivité du CPU.
            - Le mode "iowait" représente le temps pendant lequel le CPU est inactif car il attend que les opérations d'entrée/sortie (comme l'accès au disque ou au stockage) se terminent.
        - `node_load1`: Charge moyenne du systeme sur 1 minute
    
    - Memory: 
        - `node_memory_MemAvailable_bytes`: Memoire disponible pour les applications, incluant la memoire pouvant etre libéré (cache de pages, buffers). C'est l'estimation de la mémoire libre utilisable par le systeme.
        - `node_memory_MemTotal_bytes`: Memoire physique totale de l'hôte (en octets). Correspond à la RAM installé. Peut servir de référence pour calculer les pourcentages d'utilisation mémoire. 
        Mémoire utilisée : MemTotal - MemAvailable.
        - `node_memory_SwapTotal_bytes` : Taille total de l'espace swap configure sur le systeme
            - Le “swap” est une zone d’échange sur disque utilisée comme extension de la mémoire vive (RAM) quand celle-ci est saturée.
        - `node_memory_SwapFree_bytes`: Volume en bytes de swap encore non utilise et disponible pour l'echange.
        - `node_vmstat_pgmajfault`: Chargement de pages depuis le disque

    - Network:
        - `node_network_speed_bytes`: Détection d'une saturation du lien 
        - `node_network_transmit_bytes_total`: Cumule le nombre total d’octets transmis (émis) par toutes les interfaces réseau depuis le démarrage du système.
        - `node_network_receive_errs_total`: Compteur cumulatif du nombre d’erreurs survenues lors de la réception de paquets sur chaque interface réseau depuis le démarrage (ou dernière remise à zéro). Ces erreurs peuvent provenir de corruption de trame, de buffer plein, etc...
        - `node_network_receive_packets_total` : Compteur cumulatif du nombre total de paquets réseau reçus sur chaque interface depuis le démarrage.
    
    - Storage: 
        - `node_disk_io_time_seconds_total`: Pour chaque périphérique de stockage, le temps cumulé (en secondes) passé par le système à effectuer des opérations d’I/O disque depuis le démarrage.
        - `node_disk_write_time_seconds_total` : Cumul, en secondes, du temps que le système a passé à exécuter des opérations d’écriture sur chaque périphérique de stockage depuis le démarrage
        - `node_filesystem_avail_bytes`: Disponibilite taille disque
        - `node_disk_io_time_seconds_total`: Cumule, pour chaque périphérique (device=), le temps total (en secondes) passé par le noyau à traiter des opérations d’I/O (lectures + écritures) depuis le démarrage (ou la dernière remise à zéro).

## Blackbox_exporter

- *Définition* : le terme "blackbox" fait référence a la technique de test d'un service sans connaitre son fonctionnement interne. Concrètement, on n'accède qu'à l'interface publique (endpoint) et on examine les réponses obtenues (code HTTP, latence...). Ce type de test permet de simuler la vision d'un utilisateur externe et d'identifier les problèmes de connectivité ou de latence.

- *Blackbox exporter* est un composant complémentaire à Prometheus qui permet d'effectuer des tests "blackbox" de disponibilité de performance et de latence sur divers protocoles (HTTP, TCP, ICMP, DNS...). Il fonctionne en se basant sur des modules configurables qui definissent le type de probe (test) à realiser pour chaque service. On va pouvoir scrapper l'exporter lui meme mais egalement l'exporter qui scrape une ou plusieurs targets. 


## Prometheus

Bienvenue dans la documentation concernant la stack de supervision des metriques, dans ce readme nous allons passer en revu l'architecture realisee.

### Explication rapide 

- Collecte les metriques fournis par les node_exporter et autres endpoints, via pull model, c'est a dire qu'il interroge periodiquement les endpoints via HTTP. 
- Cloud-native: s'appuie sur la decouverte de services et labels
- TSDB stockage: Chaque instance stocke localement ses series temporelles
- Port d'ecoute par defaut 9090.

### Concernant le stockage TSDB et WAL

- Write-Ahead_Log: Tout nouvel echantillon est d'abrt ecrit dans un journal `append-only` qui garantit la durabilite avant ingestion dans la TSDB. Le WAL permet un redemarage rapide sans relire les blocs de doata deja persistes.
- Les blocs TSDB: 
    - `retention_time=15d`: 
    - `min-block-duration=2h` et `max-block-duration=2h`: chaque bloc contient 2 heures de données. A la fin de chaque intervalle, le bloc est “fermé” (compaction, indexation) et un nouveau bloc est ouvert. Cela facilite la suppression de données anciennes (retention) et améliore la vitesse de lecture/compaction. Aussi, cela empêche Prometheus de faire sa propre compaction locale (modification des blocs TSDB) avant que Thanos Sidecar ne les upload, cela garantit donc que Thanos uploadera a l'IDENTIQUE chaque bloc de duree fixe, sans corruption, ni rescrutation. Enfin, le sidecar detecte immediatement qu'un nouveau bloc est disponible et le pousse vers le S3.
    - Si Prometheus a déjà produit plusieurs blocs (p. ex. après redémarrage ou backlog), le Sidecar va tous les mettre en file d’attente et les envoyer l’un après l’autre (ordre chronologique).

### Concernant la Haute Disponibilite

- 3 prom actif-actif qui scrapent les memes targets
- Si 1 tombe, les deux autres continuent la collecte sans perte de metriques. 

### Concernant la configuration prometheus.yml

- global
    - Déclarations globales : scrape_interval, evaluation_interval, external_labels, etc.
    ```yaml
    global:
        scrape_interval: 20s # Default is every 1 minute.
        evaluation_interval: 1m # Default is every 1 minute.
        external_labels:
            replica: {{ replica }}
    ```
- alerting
    - Alertmanagers : listes d’instances (host:port) et options de circuit breaker. Par exemple, ci dessous on constate dans l'`alert_relabel_configs` un `action: labeldrop` qui signifie que l'on souhaite supprimer des labels et `regex: replica` qui signifie que tout nom de label correspondant au motif replica sera retire de l'alerte.  En effet, cela permet de:
        - Reduire la cardinalite: si on scrape N replica on produira N alertes identiques, une par replique, ce qui encombre alertmanager et les canaux de notification.
        - Facilite le regroupement et le routing: en supprimant le label on force le `group_by` sur des labels plus pertinents (ex: job, instance, severity). Cela permet alors d'envoyer une seule notification pour l'ensemble des replicas affectes. 
        - Optimiser la performance: moins de labels = moins de series d'alertes differentes a gerer en memoire et dans le cluster alertmanager.
    ```yaml
    alerting:
        alert_relabel_configs:
            - action: labeldrop 
              regex: replica
        alertmanagers:
            - scheme: https
            tls_config: {{ prometheus_tls_server | tojson }}
            static_configs:
                - targets:
                - {{ alertmanager_private_ip }}:{{ alertmanager_port }}
                - {{ alertmanager2_private_ip }}:{{ alertmanager_port }}
                - {{ alertmanager3_private_ip }}:{{ alertmanager_port }}
    ```
- rule_files
    - Emplacement des fichiers YAML contenant les règles d’alertes et d’enregistrement (recording rules).
- scrape_configs
    - jobs : nom, scheme (http/https), metrics_path, honor_labels, etc.
    - service_discovery : Docker, Kubernetes, Consul, file_sd_configs, etc.
    - relabel_configs & metric_relabel_configs : filtrage, renommage, enrichissement de labels.
    - tls_config, basic_auth, bearer_token, oauth2 etc. pour sécuriser l’accès aux endpoints.


### Concernant le type de [query](https://prometheus.io/docs/prometheus/latest/querying/functions/)

- `rate` : calcule le taux de changements
- `vector` : ensemble de series temporelles, qui contient une unique valeur
- `up` : service actif/non-actif
- `histogram_quantile` : estimer une valeur de quantile. Dans Prometheus, un histogramme génère plusieurs séries de données, chacune correspondant à un bucket défini par un seuil (le label généralement est « le »). Chaque bucket contient le nombre d’observations inférieures ou égales à la valeur du seuil. La fonction histogram_quantile prend en paramètre le quantile désiré (une valeur entre 0 et 1, par exemple 0.95 pour le 95ème percentile) et l’ensemble des buckets (les séries ayant le label « le »). Elle procède à une interpolation linéaire entre les buckets pour estimer la valeur de la métrique pour laquelle la fraction d’observations cumule la proportion donnée par le quantile. Concrètement, elle cherche le bucket tel que la proportion cumulée d’observations atteigne ou dépasse le quantile voulu, puis interpole entre ce bucket et le précédent pour donner une valeur approximative correspondant à ce quantile. EXEMPLE: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) permet d’estimer, sur une fenêtre de 5 minutes, la durée en dessous de laquelle se trouvent 95 % des requêtes.
- `avg` : agrege et fait une moyenne
- `on` : controle la correspondance des labels lors d'operations arithmethiques
- `predict_linear`: utilisée pour prédire la valeur future d'une métrique en fonction de son comportement passé.
- `sum` : agrege et additonne les valeurs, pour obtenir une somme ou un total

### Concernant la lecture des alertes: 
```yaml
    - alert: HostCpuIsUnderutilized
    # Calcule pour chaque instance le taux par seconde auquel le CPU reste inactif durant la dernière semaine,
    # prend la valeur la plus faible parmi ces taux (pour identifier le cas le plus critique) et vérifie si
    # cette valeur minimale est supérieure à 85% d'inactivité.
    expr: (min by (instance) (rate(node_cpu_seconds_total{mode="idle"}[1w]))) > 0.85
    for: 1w
    labels:
        severity: info
    annotations:
        summary: "Host CPU is underutilized (instance {{ $labels.instance }})"
        description: "CPU load has been < 15% for 1 week. Consider reducing the number of CPUs.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
```

- Imaginons `evaluation_interval: 15s`, prometheus (ou thanos rule) va lire 1 semaine de taux de CPU inactif et si cette valeur depasse 0.85 alors elle est a true. Il faut que pendant 1 semaine d'evaluation consecutive, cette condition soit true. Au final, il y a :
    - 1 fenetre de donnees d'1 semaine
    - 1 stabilisation temporelle d'1 semaine

### Limites constatees

- Retention et scalabilite:
    - Stockage courte duree : de 15 a 30 jours 
- No HA, necessite deduplication
    - Chaque instance est indepentant, d'ou la necessite dn deploiement actif-actif + deduplication en amont. 
- Gestion Alertmanager
    - Prometheus ne supporte pas de Load Balancing http classique au niveau alertemanager car les AM run en 'gossip cluster' et Prometheus est design pour les envoyer à tout le monde. Prometheus effectue du 'client-side balancing and retries' donc il deduplique les notifications si l'un des serveurs alertmanagers est down. Prometheus doit connaitre la liste des targets pour gérer la résilience mais ne doit pas intéragir avec un seul endpoint distribué.
- A grande echelle, probleme de surcharge si un seul prom déployé.
- Pas de cache de requete
    - Les memes requetes concurrentes sont recalculees, ce qui peut charger le serveur sous forte affluence 

## Alertmanager

### Explication rapide 

- Envoyer des alertes sur des routes différentes : webhook, mail...
- Integrer des silences et les limiter via `--silences.max-silences` flag, disable by default
- Grouper les alertes

### Concernant le fichier de config

```yaml
global:
  resolve_timeout: 6m # Delai pour qu'une alerte qui firing soit resolue

route:
  group_by: ['alertname'] # Regroupe les alertes qui partagent ces labels 
  group_wait: {{ delay }}s # Délai initial avant d'envoyer la premiere notification
  group_interval: 5m # Délai entre 2 notifs pour un meme groupe
  repeat_interval: 2h # Délai avant qu'une alerte qui est déja déclenché (firing) s'envoie de nouveau 
  receiver: 'web.hook'
  routes: 
    - matchers:
      - alertname="PrometheusAlertmanagerE2eDeadManSwitch"
      repeat_interval: 1m
      receiver: web.hook
    - matchers:
      - alertname="ThanosRuleE2eDeadManSwitch"
      repeat_interval: 1m
      receiver: web.hook

receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'https://webhook.site/1fcd3b6d-35d1-46b0-b93e-936c4dc5af34'
        send_resolved: true
inhibit_rules: # Suppression des notifications de severite warning si la severite critical correspondante est deja en cours
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'instance']

```

### Concernant le gossip alertmanagers

- Permet aux noeuds alertmanager de former un cluster HA
- S'echangeent periodiquement l'etat des alertes, des silences et des inhibitions
- Garantit la convergence des data sur tous les membres du cluster
- Possibilite d'envoyer des notifications par interval precise entre les alertmanagers pour eviter un goulot d'etrangelement entre les alertmanagers et une meilleure repartition.

### Limites constatees 
    - Risque de plusieurs notifications lorsque alertmanager est désynchronisé : AM n'a pas encore formé son cluster via les gossip, Prom envoie les alertes a plusieurs instances
    - Assez cheum, possibilite d'installer Karma sur AM-1

## Grafana

cf grafana.md

### Explication rapide

- Possibilite de creer des organisations
- Creation d'admin, de viewer ou de writer

## Thanos

1. Definition

- Permet de dedupliquer la donnée  
- Centraliser les requêtes faites a prometheus 
- Gestion des pannes et haute dispo
- Prometheus et Sidecars:
    - En cas de panne d'un prom ou de son sidecar, l'autre instance continue de collecter et de servir les metriques.
    - Thanos Query deduplique les donnees provenant de plusieurs sidecars, ce qui permet de maintenir la disponibilite des donnees meme si l'un des sidecars est temporairement indisponible.
    - Les blocs deja uploades sur S3 restent accessibles via le store gateway.

2. Thanos sidecar

- Chaque instance de prometheus est accompagne d'un sidecar, qui tourne a cote de prometheus, mieux car : 
    - Accès local aux données TSDB, sidecar lit les fichiers /data pour uploader les blocs vers S3, donc c'est fiable et sans latence réseau
    - Pas de configuration réseau a effectuer pour des acces distants
    - Simplicité de démarrage, le sidecar et prometheus repartent ensemble, donc pas de pb de désynchronisation ou d'état intermédiaire.
    - Moins de risques de corruption, acces concurrent a la TSDB de prometheus depuis l'extérieur peut être instable.
- Expose les donnees de prometheus en gRPC pour les requetes de thanos query
- Gere upload regulier des blocs de donnees historiques vers S3, protocole d'echange gRPC 
- Frequence reguliere (2h) de collecte, mais possibilite d'utiliser thanos receiver (pas une bonne pratique)

3. Thanos store ou store gateway

- Accede au backend de stockage S3 pour servir les blocs de metrics historiques, donc donnees deja uploades aux requetes de Thanos Query, port par defaut 10902
- Role tres centrale car le querier va venir l'interroger
- Si le store gateway rencontre un probleme les donnees historiques seront temporairement indisponibles, mais les donnees recentes restent accessibles via les sidecars.
- utile si on souhaite des donnees au dela de 2h
- Si tous les prometheus sont down, tous les clients (grafana par ex) peuvent requeter les blocs via le store sauf les 2h de collecte

4. Thanos query

- Interprete le promql fournit
- Agrege et deduplique les donnees provenant des differents prometheus via leurs sidecars ainsi que celles recuperees du store gateway, cela veut dire qu'il identifie les series identiques sauf pour le label replica, considere qu'elles sont les memes et n'en garde qu'une seule. Il choisit de cette facon :
    - La serie avec le plus grand nombre de samples dans la periode de requete
    - si egalite, il choisit la serie avec la source la plus rapide
    - en fonction de l'ordre d'apparition dans le store
- Propose une interface de requete unique pour les outils de visualisation, port par defaut 9090
- Thanos query est stateless, ca veut dire qu'il ne conserve aucun etat interne entre les requetes. Aucune info d'etat n'est stocke localement, il est simple d'ajouter ou de retirer des instances de thanos query sans necessiter de synchronisation de transfert de donnees d'etat. En bref, les instances ne dependent pas d'un etat partage.
- Thanos query peut etre redemarre rapidement ou replique derriere un load balancer, NLB.

5. Thanos compactor

- Responsable de la compaction, de la rétention des données, du downsampling et de la gestion des uploads partiels.
- Compaction : reduction nb de blocs = performances de lecture + requete donc fusionne les blocs TSDB, par ex: plusieurs blocs de 2h en 1 bloc de 24h
- Downsample les data pour améliorer les performances des longues requêtes
- Retention : supprime les data obsoletes selon la rétention définie + nettoie le bucket S3 et garde une structure optimisée
- Supporte la depduplication de data, utile pour eviter les doublons, notamment dans les scenarios de backfilling (Lors du backfilling, il est courant d'avoir des blocs de données qui se chevauchent dans le temps. Thanos supporte la compaction verticale, qui permet de fusionner ces blocs chevauchants en un seul bloc cohérent) ou de replication (processus de copier des données à travers plusieurs instances ou systèmes pour assurer la redondance et la haute disponibilité)
- Doit etre unique par bucket car plusieurs compactors peuvent provoquer des corruptions 
- Bien repartir en fonction des bonnes instances prom (via replica A ou B)

  --retention.resolution-raw=30d \ # Conservation data brutes 30 jours pour analyse detaillees et diagnostics rapides
  --retention.resolution-5m=180d \ # Conservation data downsamplées à une resolution de 5 minutes pdt 180 jours analyse moyen terme
  --retention.resolution-1h=1y \ # Conservation data downsamplées a une resolution de 1h pdt 1an pour du long terme
  --delete-delay=48h \ # Delai avant la suppression effective des blocs marques
  --compact.concurrency=2 \ # Controle le nb de go routines utilisees pour compacter les groupes 
  --compact.progress-interval=5m \ # Frequence a laquelle le progres de la compaction est calcule
  --enable-auto-gomemlimit \ 

- Verifier:
    thanos_objstore_bucket_operation_failures_total : Nombre total d'échecs d'opérations sur le bucket.
    thanos_objstore_bucket_operation_duration_seconds : Durée des opérations sur le bucket.
    thanos_compact_groups : Nombre de groupes de compaction.

6. Thanos Rule

Le “Ruler” de Thanos est le composant qui exécute vos règles d’alerte et d’enregistrement – un peu comme Prometheus le fait en local, mais à l’échelle d’un stockage distribué. Voici en termes simples les compromis à connaître :

    Évaluation locale (Prometheus classique)

    • Tout se passe dans une seule instance Prometheus (données et règles sur la même machine).

    • Très fiable : si Prometheus tourne, l’évaluation des règles tourne aussi, sans dépendre d’un réseau ou d’autres services.

    Évaluation distribuée (Thanos Ruler)

    • Le Ruler envoie des requêtes à un Querier Thanos, qui lui-même interroge un ou plusieurs Store APIs (vos Prometheus sidecars ou votre stockage objet).

    • Fiabilité moindre : si le Querier ou un Store est indisponible (problème réseau, surcharge, outage), vos règles peuvent échouer ou se bloquer.

    Conséquence principale

    • Avec Prometheus seul, vos alertes/recordings ne tombent pas en panne (hors crash complet de l’instance).

    • Avec Thanos Ruler, des défaillances réseau ou de composant peuvent empêcher l’évaluation, et donc retarder ou rater des alertes.

    Que faire ?

    • Prévoyez une stratégie claire pour gérer les interruptions :

    – Décidez si vous préférez que les alertes se déclenchent quand même sur d’anciennes données (stale data) ou qu’elles soient mises en pause.

    – Configurez des délais de tolérance (“for” dans vos règles) ou des redondances de Ruler/Querier pour minimiser les interruptions.

    • Surveillez la santé de votre Querier et de vos Stores pour réagir vite en cas de panne.

En résumé, Thanos Ruler permet d’évaluer des règles à grande échelle sur un stockage distribué, mais il introduit des dépendances réseau : il faut accepter qu’en cas d’indisponibilité de certains composants, vos règles d’alerte peuvent échouer, et mettre en place des mécanismes pour y faire face.
- *Definition*:

7. Limites

- Consommation de ressources importantes
- Si perte d'1 prometheus, on perd 2h de donnees car frequence reguliere sauf s'il y en a un autre

# Logs

- *Definition*: 
    - Enregistrements séquentiels d’événements et des messages produits par un système ou une application. Ils fournissent des détails spécifiques sur ce qui s’est passé à un moment donné. Les logs sont particulièrement utiles pour le débogage, la recherche d’erreurs et la compréhension du flux d’exécution d’une application. Ils contiennent souvent des informations sur les exceptions, les messages d’erreur, les transactions réussies, etc.

1. ELK
    - Logstash : collecter et transformer
    - ElasticSearch : chercher et analyser
    - Kibana : visualiser et manager

- Avec ces 3 technos:
    - **Indexing et Stockage**: index full text of logs, more granular search, utilise un index inverse qui facilite la recherche. cout eleve en stockage et ressource
    - **Scalability** : ajout de nodes par logstash et scaled en distribuant les logs a travers multiple instances. 
    - **Querying et Visualisation** : robuste query language KQL, bon dashboard.
    - **Ease of Use** : un peu complexe car il y a plusieurs techno a interconnecte
    - **Cout** : depend du nb de machine

2. Grafana + Loki + Promtail
    - Promtail : agent responsable de collecter les logs et les push sur le serveur Loki
    - Loki Server : enregistre et index les logs
    - Grafana : outil de visu integre avec Loki pour querying et afficher log data

- Avec ces 3 technos:
    - **Indexing et Stockage**: index seulement metadata, tres efficace en terme de stockage et de ressource. Grand volume de log ? Log sont stocke de maniere similaire a Prometheus, en chunk, et index par labels donc key-values.
    - **Scalability**: Large volume de log avec une infra tres faible en cout, mais struggle sur les grands volumes
    - **Querying et Visualisation** : bon dashboards + grafana query language LogQL
    - **Ease of Use** : apparemment simple
    - **Cout** : low

## Rsyslog

Rsyslog est un système de gestion des logs très utilisé sous Linux. Il permet de centraliser les logs provenant de différentes sources, offrant des fonctionnalités avancées telles que :

- `Filtrage` : Possibilité de filtrer les messages de log selon des critères spécifiques.
- `Redirection` : Envoi des logs vers divers destinations, y compris des fichiers, des bases de données ou des systèmes de gestion de logs centralisés.
- `Extensibilité` : Supporte des modules pour intégrer des fonctionnalités supplémentaires, comme le traitement des logs en temps réel.

## Fluentbit

Fluent Bit est un collecteur de logs léger et performant, idéal pour les environnements à ressources limitées. Il sert de passerelle entre les logs et les bases de données, et peut remplacer des outils plus lourds comme Logstash. Ses principales caractéristiques incluent :

- `Performance` : Conçu pour être rapide et consommer peu de ressources.
- `Flexibilité` : Supporte divers formats de logs et protocoles de transport.
- `Intégration` : Peut être facilement intégré dans des architectures de microservices et des environnements cloud.

## Logstash

Logstash est un outil de traitement des données qui permet de collecter, transformer et enrichir les logs avant de les envoyer vers une destination, comme Elasticsearch. Ses principales caractéristiques incluent :

- `Pipeline de traitement` : Permet de définir des pipelines complexes pour le traitement des données, incluant des étapes de filtrage, de transformation et d'enrichissement.
- `Support de multiples sources` : Capable de collecter des logs à partir de diverses sources, y compris des fichiers, des bases de données, des systèmes de messagerie, et des API.
- `Plugins extensibles` : Dispose d'une large gamme de plugins pour l'entrée, le filtre et la sortie, permettant une personnalisation selon les besoins spécifiques de l'utilisateur.
- `Facilité d'intégration` : S'intègre facilement avec d'autres outils de l'écosystème ELK (Elasticsearch, Logstash, Kibana) et d'autres systèmes de gestion des logs.


## Filebeat

Filebeat est un agent léger conçu pour la collecte de logs. Il est souvent utilisé pour envoyer des logs vers Logstash ou Elasticsearch. Voici ses caractéristiques clés :

- `Légèreté` : Conçu pour être peu gourmand en ressources, ce qui le rend idéal pour des environnements à grande échelle.
- `Surveillance des fichiers` : Capable de surveiller des fichiers de logs en temps réel et d'envoyer les nouvelles entrées dès qu'elles sont écrites.
- `Configuration simple` : Facile à configurer avec des fichiers de configuration simples, permettant une mise en place rapide.
- `Intégration avec l'écosystème ELK` : Fonctionne de manière fluide avec Logstash et Elasticsearch, facilitant la centralisation et l'analyse des logs.

### Promtail

Promtail est un outil léger qui collecte les logs des fichiers et les envoie à Loki pour stockage et analyse. Ses principales caractéristiques incluent :

- `Collecte de logs` : Promtail surveille les fichiers de logs sur le système de fichiers et envoie les nouvelles entrées à Loki en temps réel.
- `Étiquetage des logs` : Il permet d'ajouter des labels aux logs, facilitant ainsi leur organisation et leur recherche dans Loki. Ces labels peuvent être basés sur des métadonnées, comme le nom du fichier ou l'environnement d'exécution.
- `Configuration flexible` : Promtail utilise un fichier de configuration YAML, permettant de définir facilement les sources de logs, les modèles d'étiquetage et les règles de traitement.
- `Intégration avec Grafana` : En tant que composant de l'écosystème Grafana, Promtail s'intègre parfaitement avec Loki et Grafana, permettant une visualisation et une analyse des logs en temps réel.
- `Support des pipelines de traitement` : Bien qu'il soit plus simple que Logstash, Promtail permet également des transformations de logs de base avant l'envoi à Loki.

## Elasticsearch

Elasticsearch est une base de données NoSQL orientée documents, particulièrement adaptée pour la recherche et l'analyse de grandes quantités de données. Ses atouts incluent :

- `Recherche en texte intégral` : Permet des recherches rapides et efficaces sur des données non structurées.
- `Scalabilité` : Conçu pour gérer des volumes de données croissants sans compromettre la performance.
- `API RESTful` : Facilite l'intégration avec d'autres applications et services.

## Loki

Loki est un système de gestion des logs développé par Grafana Labs, conçu pour être simple et efficace. Il se distingue par :

- Indexation minimale : Contrairement à d'autres systèmes, Loki n'indexe que les métadonnées, ce qui réduit la complexité et améliore la performance.
- Intégration avec Grafana : Permet une visualisation facile des logs aux côtés des métriques et des traces.
- Support des labels : Utilise un modèle de labels pour organiser et filtrer les logs, facilitant ainsi leur recherche et leur analyse.


## Kibana

Kibana est un outil de visualisation de données qui fonctionne en tandem avec Elasticsearch. Il permet de créer des tableaux de bord interactifs et des visualisations graphiques des données de logs. Ses fonctionnalités comprennent :

- Visualisations variées : Graphiques, cartes, et tableaux pour représenter les données de manière intuitive.
- Exploration des données : Permet d'explorer les logs en temps réel et d'identifier rapidement les anomalies.
- Tableaux de bord personnalisables : Créez des tableaux de bord adaptés aux besoins spécifiques de votre équipe.

