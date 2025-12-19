# VIGINUM

**ATTENTION AUX INFOS, CERTAINES SERONT A VERIFIER, REPRENDRE LES NOTES DU CARNET** 

## Missions de Viginum + Teams
- Viginum, service du premier ministre, plus exactement du secretariat générale de la défense et de la sécurité nationale
- Protection contre les ingerences numeriques etrangeres avec une approche acteurs/entitées et explore des narratifs
- Existe grace a deux décrets: 
    - Décret de juillet 2021
    - Décret de décembre 2021
- 4 critères d'une ingérence numérique étrangère (INE):
    - Contenu faux ou trompeur
    - Volonté d'atteinte aux intérêts fondamentaux de la nation
    - Implication directe ou indirecte 
    - Diffusion ou volonté de diffusion
- Plusieurs notes:
    - Note bleu: souvent courte, et détection de petite manoeuvre 
    - Note violette: informative ?
    - Note rouge: qui répond aux 4 critères, souvent plus longue


- Analyste : 
    - **ARTHUR: Moyen-Orient**
        - Investigue sur la situation au moyen-orient (Israel, Iran, Azerbaidjan) mais également en Turquie et depuis pas longtemps, le Maroc et l'Algérie (pas sur pour les deux derniers pays...) dont les acteurs peuvent tant etre des acteurs étatiques que des entreprises privées. 
        

    - **BRUCE: Russe**
        - La plus ancienne opération de viginum
        - Fusion de 3 opérations: 
            - Ursule (guerre en ukraine)
            - Salomé (Sahel)
            - Eustache (Projet Lakhta)
        - La russie a un dispositif d'influence numérique depuis plus de 100 ans déja, tres fort dans la guerre informationnelle
        - Les acteurs étatiques sont nombreux:
            - GRU, FSB
            - Aministration présidentielle (Kremlin)
        - Les acteurs privées:
            - Oligarques
            - Prestataires privées
        - Acteurs tiers étrangers: [...]
        - Narratif:
            - Preparation de contenus trompeurs
            - Publication en ligne
            - Amplification sur les plateformes (toutes plat confondues)
        - Mriya: Ukraine...?
        - Golos et Euromore...?
        - Lakhta...?

    - **SILOE: Chine**
        - Création en 2022
        - Thématiques qui ont suscité intéret des acteurs chinois:
            - Taiwan
            - Traitement Ouighours
        - Acteurs parti-état:
            - Ministre des affaires étrangères
            - ...
        - [...]
    - **EDWARD: Acteurs d'extreme droite**
        - Extreme droite
        - Inde
    - **ANTIGONE: Anticipation menace**
        - Mission de documenter les risques systémiques, les acteurs et usagers, plateformes et acteurs techniques
        - Connaitre acteurs + pratiques (Mercenaires d'influences, blackhat, SEO)
        - Dev ou utilisation d'outils pour:
            - Mesurer risques d'impact
            - Vigiconstellation: regroupe et index les publications + comptes sur une période pour avoir des diagrammes et métriques 
            - Wikip analyse
            - newswhip: crossplateforme d'info
        - Sensibilise aux risques:
            - Communication/boite a outils powerpoint
            - linkedin
        - Espionnage: 
            - Watering hole
            - Phishing
            - Siri Deactivation
    - **TRANSVERSE: point de contact**
        - Chaque opération a un point de contact pour aborder des sujets transverses
        - Communautés des renseignements: DGSE, DGSI...

- Tech: 
    - Capitalisation:
        - Knowledge management
        - Installation d'outils
        - 3 chantiers:
            - La veille: technologies, métiers avec entretiens individuels, formation de méthodologie de veille, freshrss experience utilisateurs
            - Capitalisation: analyse..., capacity building, Deploiement openCTI
            - Documentation du savoir faire: 
        
    - Data (datalab):
    - Infra:

- DivOps: Gestion des opérations
    - **Détecter et caractériser une INE**
    - **CyberThreatIntelligence**
    - **Acteurs étrangers sur la France**
    - **Comité Operationnel sur la Lutte contre les Manipulations de l'informations**

## Notions apprises et a detaillées, hors sujet principale du stage et ayant aidé 

- Cloud provider + Terraform
    *cf tf monitoring*
    - NAT service: access des IP privees vers internet
    - security_group 
- Ansible
    *cf ansible monitoring*
    - *Difference entre fork et serial*: 
        - **forks**: Nb de processus paralleles lances par Ansible pour executer une tache sur plusieurs hotes en meme temps. Configuration au niveau du controleur ansible, et du playbook avec async. Forks = 10 donc 10 processus en parralele.
        - **serials**: Nb d'hotes a traiter a la fois dans un playbook. Configuration au niveau du playbook.
    - ansible.cfg

- .envrc, direnv: 
    - Agit comme une extension du shell et permet de charger ou d'unset des variables d'environnement en fonction de dossier ou `.envrc` se situe. 

- Modèle OSI:
    - **Trames (Mac address)** 
        - Tous les équipements machines réseaux (carte réseaux) ont un identifiant unique (router, switch, ordinateurs) sur lequel on souhaite envoyer des informations. C'est la dernière couche d'encapsulation avant la transmission des données sur la couche physique. Ca commence souvent par AA:BB:CC:FF et avant que le réseau existe, on utilisait des switch pour envoyer des informations d'un bout a l'autre. Il fallait renseigner le port sur lequel il doit envoyer la donnée. Cette info est envoyé en binaire.
    - **Reseaux (paquet)**
        - Il n'y allait pas avoir assez de Mac address, alors on a crée le réseau dont l'unité de donnée est appelé le paquet, qui contient l'information (data à envoyer) et les métadonnées (vers qui on envoie la donnée). Exemple : 10.0.0.0/16 donc les 16 premiers bits seront réservés a l'hote et les 16 autres au réseau. Si on souhaite calculer en binaire par exemple : 10.192.3.253/16 on cherchera a savoir combien il y a de puissance de 2 au sein de ce réseau. 
        Topologie : 
            2p0 = 1
            2p1 = 2
            2p2 = 4
            2p3 = 8
            2p4 = 16
            2p5 = 32
            2p6 = 64
            2p7 = 128
        Donc pour '10', il y aura 1 fois 2p3 et 1 fois 2p1 et 0 fois pour les autres, 
        pour '192', il y aura 1 fois 2p7 et 1 fois 2p6, 
        pour '3', il y aura 1 fois 2p1 et 1 fois 2p0 
        et enfin pour '253', il y aura 1 fois 2p7, 1 fois 2p6, 1 fois 2p5, 1 fois 2p4, 1 fois 2p3, 1 fois 2p2 et 1 fois 2p0  donc en commencant par le bit le plus fort (2p7): 00001010.11000000.00000011.11111101.

        - Lorsqu'on envoie une donnée, il y a '[ip_src, ip_dest, mac_src, mac_dest]' donc exemple, 10.2.4.5 souhaite envoyer un msg a 10.2.4.6. Il va passer par la table de routage pour savoir si cette IP existe, sinon broadcast. Le routage est la détermination d'un chemin permettant de relier 2 machines distantes qui souhaitent communiquer. 
    
    - **TCP/IP (segment) couche transport**:
        - *Transmission Control Protocol/Internet Protocol* désigne une suite de protocoles de communication qui permet d'assurer l'interopérabilité entre différents types de réseaux et d'appareils, garantissant que des milliards de dispositifs peuvent communiquer efficacement et atteignent leur destination dans le bon ordre.
        - *Orienté connexion*: établit une connexion entre l'émetteur et le destinataire en utilisant un processus appelé "handshake"
        - *Fiabilité* ...
        - *Controle de flux et congestion* ...
        - *Transmission ordonnée* ...
        - *Confirmation de Réception* ...

    - **UDP**
        - *User Datagram Protocol* est un protocole de communication utilisé dans les réseaux informatiques qui fait partie de la suite de protocoles d’Internet.
        - *Sans Connexion* n'établit pas de session de communication formelle entre l'expéditeur et le destinataire avant d'envoyer les données. 
        - *Rapide et Léger* délai de communicaion rapide
        - *Sans garantie de livraison* ni vérification de l'ordre ou intact
        - *Utilisations courantes*  scénario qui demande de la vitesse (streaming, vidéo en direct; jeux en ligne)
        - *Multidiffusion et difffusion* 

- SSH
    - *Definition*: Anciennement Telnet sauf que la connexion etait en clair et donc non securise, SSH est une maniere securise de se connecter a distance aux machines/serveurs...
    - **Tunnels ssh**: 
        - Creation tunnel SSH afin d'acceder a l'API:
        ```sh
        ssh -L 8080:localhost:9090 outscale@<public_ip> -o "StrictHostKeyChecking=no"
        ```
        a la place de outscale, ajout du user par defaut, ca aurait pu etre ubuntu
        - Acces VM avec proxy jump + SSH:
        ```sh
        ssh -J outscale@142.44.60.74 -L 9090:localhost:9090 outscale@10.15.17.190 -o StrictHostKeyChecking=no
        ```
    - **Bastion ssh**:
        - Creation d'un bastion SSH en tant que Proxy Jump, on peut alors durcir les entrees avant que l'utilisateur se dirige vers la destination finale: user, mdp, autres args ssh...
        ```conf 
        # Metrics Monitoring

        Host 10.15.*.*
        ProxyJump outscale@142.44.60.74
        StrictHostKeyChecking no

        Host 142.44.60.74
        StrictHostKeyChecking no
        ```

- DNS
    - *Définition* Le Domain Name System permet aux utilisateurs d'accéder facilement aux ressources en ligne sans avoir à retenir ou saisir des addresse IP numériques. Il repose sur plusieurs composant clés: 
        - *Serveur de noms racine* Point de départ de toutes les requête DNS. Fournit des infos de base poour orienter les requêtes vers les serveurs TLD.
        - *Serveur Top Level Domain* Ces serveurs gèrent les domaines de premier niveau, tels que .com, .org ou .fr. Les serveurs TLD poivent vers les serveurs de noms faisant autorité pour un domaine spécifique.
        - *Serveur de nom faisant autorité* Chaque domaine dispose d'un serveur de nom qui contient les enregistrements DNS. 
        - *Serveur de cache DNS* Stocke temporairement les réponses aux requêtes DNS pour accélerer le processus.

- PKI
    - *Définition générale*: Infrastructure de clé publique est un systeme qui gere la creation, la distribution, l'utilisation et la révocation des certificats numeriques et des clés cryptographiques. S'utilise sur les sites internets, serveurs, load balancer, kubernetes, VPN... Joue un role critique dans la stratégie "Zero Trust". Cela permet d'assurer l'authenticite, la confidentitalite et l'intégrité des communications entre des applications. Ces certificats utilisent le protocole TLS, qui utilise des algorithmes de chiffrement avancé (Diffie-Hellman).

    - *Clé privée*:
        - *C'est une donnée secrete générée pour chaque entité, qui permet de signer des données ou de déchiffrer des messages*, donc deux usages:
            1. **Signature numérique**: Garantit que le message provient bien de l'entité qui détient la clé.
            2. **Déchiffrement**: Seule la clé privée peut déchiffrer un message qui a été chiffré avec la clé publique correspondante.
        
        - *Exemple*: Serveur prometheus, la clé privée permet de signer un certificat qui sera présenté lors d'une connexion sécurisée.

    - *Clé publique*:
        - *La clé correspondante a la clé privée, qui peut etre librement diffusée. Elle est incluse dans le certificat numérique et sert à vérifier une signature ou a chiffrer des messages destinés à l'entité possédant la clé privée*, donc deux usages.
            1. **Verification de signature**: permet a une autre partie de verifier que le message signé provient réellement de la personne. Exemple: serveur node exporter veut savoir si le message signé provient du serveur prometheus.
            2. **Chiffrement**: Un message chiffré avec la clé publique ne peut être déchiffré qu'avec la clé privée correspondante.
        
        - *Exemple*: Certficat de prometheus contient sa clé publique. node_exporter, lorsqu'il recoit une connexion utilise cette clé pour vérifier la signature de Prometheus et s'assurer de son authenticité.

    - *Plusieurs rôles essentiels*:
        - **Emission des certificats numériques**: CA signe les certificats numériques, en associant leur clé publique a leur identité. Exemple: vault, configuré avec le moteur PKI, va agir en tant que CA pour signer les certificats de Prometheus et node_exporter.
        - **Distribution des certificats**: certificats signés (contenant la clé publique) sont diffusés aux serveurs concernés. Chaque serveur peut ainsi présenter son certificat lors d'une connexion sécurisée.
        - **Gestion de la chaine de confiance**: chaque certificat signé par la CA peut etre vérifié par n'importe quel client qui possède le certificat *racine* de la CA. Cela permet d'établir une chaine de confiance. Exemple: node_exporter lorsqu'il recoit une connexion de prometheus, vérifie que le certificat de prometheus a été signé par ma CA (gérée par Vault).
        - **Revocation des certificats**: En cas de compromission, la CA peut révoquer un certificat. Cela se fait via un CRL ou un service de vérification (OSCP).

    - *Root CA*: 
        La root CA ne reconnait pas activement ce qu'il a signé en gardant une liste de certificats. En réalité, il signe chaque certificat en utilisant sa clé privée pour générer une signature cryptographique qui est intégrée dans le certificat lui-même. 
        Lorsqu'un client ou un serveur recoit ce certificat, il utilise la clé publique du Root CA (présente dans le fichier ca.crt) pour vérifier que la signature correspond bien aux données du certificat.
    
    - *Différence entre TLS et mTLS*:
        - **TLS** : Assure la confidentialité et l'intégrité des données entre deux parties en chiffrant les données échangées. 
            - Authentification serveur: présente certificat serveur au client, ce cert est signé par la ROOT CA, le client vérifie que le certificat est valide et que le nom du serveur correspond a celui attendu ('sans', 'common name').
            - Pas d'authentification client obligatoire ... 
        
        - **mTLS** :
            - Authentification mutuelle: bien déterminé qui sera client et serveur au moment de la génération du certificat 

        - **Acheminement mTLS** 
            - Generer certificat + clé privée avec vault PKI
                - Si certificat serveur, alors il doit verifier le certificat client car c'est le client qui demande a récup la data exposée. 
                - Si certificat client, alors s'authentifie auprès du serveur
                - Upload la liste des certificats pour chaque machine...
                - Attention, le navigateur ne comprends que les fichiers p12... donc conversion de la root CA en p12 sur la machine hote.

- KeepAlived:
    - *Definition*: Soft utilisant le protocole VRRP (virtual round redundancy protocol) pour permettre a plusieurs machines d'elire un master qui portera l'IP Virtuelle (VIP). Chaque VM participe a l'election, et : 
        - 1 seule machine est **MASTER** a un instant donne : elle detient la VIP
        - les autres sont en **BACKUP**, elles surveillent le master en envoyant des paquets VRRP
        - si le master tombe, une autre machine prend le relai et devient le nouveau master 
    - confcmds:
        - state # MASTER ou BACKUP
        - advert_int 1 # ping toutes les secondes
        - priority # priorite sur les autres IP, si valeur plus haute alors MASTER sauf si perte du service
        - interval: a quelle frequence le script devrait tourner 
        - timeout: comme d'hab
        - rise: cb de fois le script devrait return "success" pour qu'on considere l'hote "healthy"
        - fail: cb de fois le script devrait return "fail" pour qu'on considere l'hote "unhealthy"
    
    - *Limites*: 
        - nb de requetes : goulot d'etranglement

- Vault
    - *Def*: Vault c'est un gestionnaire de secrets. Les secrets = credentials (token, api), a suivre : vault PKI, vault secrets.

- NTP
    - *Def*: Network time protocol servant a uniformiser l'horloge des systemes sur un seul fuseau horaire.
    - Installation de ntp serveur, a savoir chronyc server, puis d'installer chronyc client partout. 

- HAproxy: 
    - Loadbalancer permettant de repartir la charge des requetes vers d'autres IPs...

- Kind (K8s)
    - Kubernetes in docker... 

- Mkdocs
    - tres utiles pour faire de la docs

- Bucket S3:
    - Minio S3
    - Ceph

- Keycloak:
    - *Def*: Solution opensource robuste pour la gestion des identites, des acces, et repond aux besoins en matiere d'authentification, securisation et stockage (stateful mais peut db aussi). 
    - *Fonctionnalites*:
        - Authentification: prend en charge plusieurs methodes d'auth (OAuth2, OpenID Connect, SAML)
        - Gestion des users: permet de creer, gerer et supprimer des utilisateurs, ainsi que de definir des roles et des permissions
        - Securisation: 2FA, Public key usage pour 
        - Stockage: stateful, keycloak gère les sessions utilisateur, ce qui signifie qu'il conserve des informations sur les connexions actives, les tokens d'accès, et les sessions d'authentification. Cela permet de gérer des fonctionnalités comme la déconnexion et le renouvellement des tokens.

    - Possibilite de configurer keycloak comme un middleware d'authentification, cela implique de verifier les tokens JWT fournis par keycloak lors des requetes users.

## Notions apprises sujet principal 

cf monitoring_infra.md

## Presentation video de stage 

J'ai effectue un stage de 6 mois au sein d'un service du SGDSN (Secretariat General de Defense et de la Securite Nationale) qui se nomme VIGINUM, du 3 fevrier au 1er aout 2025.

VIGINUM est un service technique et operationnel chargé de la vigilance et de la protection contre les ingérences numériques étrangères. Créé le 13 juillet 2021 par décret, il répond a un defi majeur : preserver le débat public contre les campagnes de manipulation de l'information impliquant des acteurs etrangers sur les plateformes numériques et qui ont pour but de nuire a la France et à ses intérets. Ses missions sont de détecter ces campagnes et d'en étudier les caractéristiques. Cela passe par plusieurs équipes d'analystes qui décrypte leur mode opératoire, leur construction narrative et son origine. Il existe des raports publics explicitant les resultats des travaux des analystes, pour n'en citer que quelqu'uns: `UN-notorious BIG` une campagne numerique de manipulation de l'information ciblant les DROM-COM et la Corse, `Manipulation d'algorithmes et instrumentalisation d'influenceurs` enseignement de l'election presidentielle en Roumanie & risques pour la france ou encore `African Initiative` decrivant les modes operatoires informationnelles pro-russe en Afrique (dire mettre pause et copier les liens).  

J'ai rejoint l'équipe infra en tant qu'Ingenieur DevOps et ma mission a principalement était l'installation d'une stack de monitoring tiré d'outils open-source comme Prometheus, Grafana, Alertmanager, Thanos pour les metrics, et Elasticsearch, Loki (pour les DB special log), fluentbit + filebeat + promtail + rsyslog + logstash (des outils log shipper, aggrege, transformer), kibana ou encore grafana again (visualisation).
Le but étant de prévenir, d'alerter les personnes d'un comportement inhabituel sur leur systemes d'informations. J'ai segmenté cette mission en 2 grandes parties : métriques puis logs.

Tout d'abord j'ai recu une formation interne poussee sur les bases du réseau et de l'administration des systemes Linux, par exemple, le modele OSI (Mac address, Switch, Router, IP, TCP, protocole applicatifs) les pare-feu, le chiffrement, le radius ou encore le ssh, bastion ssh, systemd et permissions...
Cela m'a servi a automatiser, grace a OpenTofu, le deploiement de mon infrastructure sur le cloud de maniere securisee sur outscale afin de developper, tester et certifier le bon resultat de mes travaux.

Ensuite, concernant les metriques, j'ai installe des exporters (node_exporter, blackbox_exporter) pour exposer les metriques systemes et reseau, les trier en fonction des zones préalablement définies par l'équipe (job, labels en zone admin ou zone management etc..) avec prometheus, visualiser ces zones (dashboard grafana), définir des alertes (rules comportement inhabituel sur prometheus), et de les envoyer aux personnes concernées via un canal commun (webhook, mail, messagerie instantanée via alertmanager), enfin, gérer la redondance et la haute disponibilité avec thanos (S3 et déduplication de la donnée). 

J'ai automatise l'installation, la configuration et la securisation des services sus-cites via Ansible et Hashicorp Vault PKI et Vault KV Secrets.

Enfin, pour la partie log dont on a pas eu le temps de mettre en production faute de temps sur l'automatisation, j'ai d'abord commence par confectionner des elements de tests donc de recuperer plusieurs type de logs comme les logs systemes et reseaux, les logs applicatifs (nginx on-premise, nginx dans un container gere par kubernetes), les logs docker et/ou kubernetes  ou encore les logs database (postgresql).
J''ai d'abord mis en place la stack de log, loki promtail puis Elasticsearch Kibana et fluentbit, puis Elasticsearch Kibana rsyslog et enfin Elasticsearch Kibana logstash et filebeat. 
 

