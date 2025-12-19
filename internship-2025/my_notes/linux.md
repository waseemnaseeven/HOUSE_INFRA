# Linux things

## Systemd unit

| **Section** | **Directive** | **Description** |
|-------------|---------------|-----------------|
| **[Unit]** | `Description` | Description courte du service. |
| **[Unit]** | `Documentation` | URL vers la documentation du service. |
| **[Unit]** | `After` | Liste des unités qui doivent être démarrées avant ce service. |
| **[Unit]** | `Before` | Liste des unités qui doivent être démarrées après ce service. |
| **[Unit]** | `Requires` | Liste des unités dont ce service dépend. |
| **[Unit]** | `Wants` | Liste des unités qui sont souhaitées mais non obligatoires pour ce service. |
| **[Unit]** | `Conflicts` | Liste des unités qui ne peuvent pas être exécutées en même temps que ce service. |
| **[Unit]** | `Condition...` | Conditions qui doivent être remplies pour que le service soit démarré (ex. `ConditionPathExists`). |
| **[Unit]** | `Assert...` | Assertions qui doivent être vraies pour que le service soit démarré (ex. `AssertPathExists`). |
| **[Service]** | `Type` | Type de service (ex. `simple`, `forking`, `oneshot`, `notify`, `dbus`, `idle`). |
| **[Service]** | `ExecStart` | Commande pour démarrer le service. |
| **[Service]** | `ExecStop` | Commande pour arrêter le service. |
| **[Service]** | `ExecReload` | Commande pour recharger la configuration du service. |
| **[Service]** | `Restart` | Politique de redémarrage du service (ex. `on-failure`, `always`, `on-abort`, `no`). |
| **[Service]** | `User` | Utilisateur sous lequel le service doit être exécuté. |
| **[Service]** | `Group` | Groupe sous lequel le service doit être exécuté. |
| **[Service]** | `WorkingDirectory` | Répertoire de travail du service. |
| **[Service]** | `Environment` | Variables d'environnement à définir pour le service. |
| **[Service]** | `Limit...` | Limites de ressources (ex. `LimitNOFILE`, `LimitNPROC`). |
| **[Service]** | `TimeoutStartSec` | Délai d'attente pour le démarrage du service. |
| **[Service]** | `TimeoutStopSec` | Délai d'attente pour l'arrêt du service. |
| **[Service]** | `PIDFile` | Chemin vers le fichier PID du service. |
| **[Service]** | `KillMode` | Mode de terminaison du service (ex. `control-group`, `process`, `mixed`, `none`). |
| **[Service]** | `RestartSec` | Délai d'attente avant de redémarrer le service. |
| **[Install]** | `WantedBy` | Cible qui active ce service (ex. `multi-user.target`). |
| **[Install]** | `RequiredBy` | Cible qui nécessite ce service. |
| **[Install]** | `Alias` | Alias pour ce service. |
| **[Install]** | `Also` | Autres unités à installer avec ce service. |
| **[Install]** | `DefaultInstance` | Instance par défaut pour les services templatés. |

