Section [paths]

    data : Chemin où Grafana peut stocker des fichiers temporaires, des sessions, et la base de données SQLite3 (si utilisée).
    temp_data_lifetime : Durée après laquelle les fichiers temporaires dans le répertoire data sont supprimés.
    logs : Répertoire où Grafana stocke les journaux.
    plugins : Répertoire où Grafana recherche les plugins.
    provisioning : Répertoire contenant les fichiers de configuration de provisioning que Grafana applique au démarrage et en cours d'exécution.

Section [server]

    protocol : Protocole utilisé par le serveur (http, https, h2, socket).
    min_tls_version : Version minimale de TLS autorisée.
    http_addr : Adresse IP à laquelle le serveur se lie. Vide pour se lier à toutes les interfaces.
    http_port : Port HTTP utilisé par le serveur.
    domain : Nom de domaine public utilisé pour accéder à Grafana depuis un navigateur.
    enforce_domain : Redirige vers le domaine correct si l'en-tête d'hôte ne correspond pas.
    root_url : URL complète utilisée pour les redirections et les emails.
    serve_from_sub_path : Indique si Grafana doit être servi depuis un sous-chemin spécifié dans root_url.
    router_logging : Active la journalisation des requêtes web.
    static_root_path : Chemin relatif pour les fichiers statiques.
    enable_gzip : Active la compression gzip.
    cert_file, cert_key, cert_pass : Chemins vers les fichiers de certificat et de clé pour HTTPS.
    certs_watch_interval : Intervalle de surveillance des changements dans les fichiers de certificat.
    socket_gid, socket_mode, socket : Configuration pour les sockets Unix.
    cdn_url : URL du CDN pour les ressources statiques.
    read_timeout : Délai d'attente pour lire les requêtes entrantes.
    server.custom_response_headers : En-têtes de réponse HTTP personnalisés ajoutés à chaque réponse.

Section [environment]

    local_file_system_available : Indique si le système de fichiers local est disponible pour Grafana.

Section [grpc_server]

    network : Type de réseau utilisé par le serveur gRPC (tcp, unix).
    address : Adresse et port sur lesquels le serveur gRPC écoute.
    use_tls : Indique si TLS est utilisé pour les connexions gRPC.
    cert_file, key_file : Chemins vers les fichiers de certificat et de clé pour TLS.
    max_recv_msg_size, max_send_msg_size : Tailles maximales des messages reçus et envoyés.
    enable_logging : Active la journalisation des appels gRPC unaires.

Section [database]

    type : Type de base de données utilisé (mysql, postgres, sqlite3).
    host, name, user, password : Paramètres de connexion à la base de données.
    url : URL de connexion à la base de données.
    max_idle_conn, max_open_conn : Nombre maximal de connexions inactives et ouvertes.
    conn_max_lifetime : Durée de vie maximale des connexions.
    log_queries : Active la journalisation des requêtes SQL.
    ssl_mode : Mode SSL pour les connexions à la base de données.
    ssl_sni : Active SNI pour les connexions SSL.
    isolation_level : Niveau d'isolation des transactions.
    ca_cert_path, client_key_path, client_cert_path, server_cert_name : Chemins vers les fichiers de certificat et de clé pour SSL.
    path : Chemin vers le fichier de base de données SQLite3.
    cache_mode : Mode de cache pour SQLite3.
    wal : Active le mode Write-Ahead Logging pour SQLite3.
    migration_locking : Verrouille la base de données pour les migrations.
    locking_attempt_timeout_sec : Délai d'attente pour obtenir le verrou de migration.
    query_retries, transaction_retries : Nombre de tentatives de réessai pour les requêtes et transactions en cas d'échec.
    instrument_queries : Active la métrique et le traçage des requêtes de base de données.

Section [remote_cache]

    type : Type de cache distant (redis, memcached, database).
    connstr : Chaîne de connexion pour le cache distant.
    prefix : Préfixe ajouté aux clés dans le cache distant.
    encryption : Active le chiffrement des valeurs stockées dans le cache distant.

Section [dataproxy]

    logging : Active la journalisation des requêtes de proxy de données.
    timeout : Délai d'attente pour lire les en-têtes de réponse.
    dialTimeout : Délai d'attente pour établir une connexion TCP.
    keep_alive_seconds : Intervalle pour envoyer des sondes keepalive.
    tls_handshake_timeout_seconds : Délai d'attente pour le handshake TLS.
    expect_continue_timeout_seconds : Délai d'attente pour recevoir la réponse du serveur après l'envoi des en-têtes de requête.
    max_conns_per_host : Nombre maximal de connexions par hôte.
    max_idle_connections : Nombre maximal de connexions inactives maintenues.
    idle_conn_timeout_seconds : Délai d'attente pour fermer les connexions inactives.
    send_user_header : Ajoute l'en-tête X-Grafana-User aux requêtes si l'utilisateur n'est pas anonyme.
    response_limit : Limite la taille des réponses des sources de données.
    row_limit : Limite le nombre de lignes retournées par les sources de données SQL.
    user_agent : Valeur personnalisée pour l'en-tête User-Agent des requêtes de proxy de données.

Section [analytics]

    reporting_enabled : Active l'envoi des statistiques d'utilisation à Grafana Labs.
    reporting_distributor : Nom du distributeur de l'instance Grafana.
    check_for_updates : Vérifie les mises à jour de Grafana.
    check_for_plugin_updates : Vérifie les mises à jour des plugins.
    google_analytics_ua_id, google_analytics_4_id, google_tag_manager_id : IDs pour Google Analytics et Google Tag Manager.
    rudderstack_write_key, rudderstack_data_plane_url, rudderstack_sdk_url, rudderstack_config_url, rudderstack_integrations_url : Paramètres pour RudderStack.
    intercom_secret : Secret pour hacher l'ID utilisateur avant de l'envoyer à Intercom.
    application_insights_connection_string, application_insights_endpoint_url : Paramètres pour Application Insights.
    feedback_links_enabled : Active les liens de feedback dans l'interface utilisateur.
    reporting_static_context : Contexte statique ajouté aux événements d'analyse.
    browser_console_reporter : Active la journalisation des événements d'interaction dans la console du navigateur.

Section [security]

    disable_initial_admin_creation : Désactive la création automatique de l'utilisateur admin au premier démarrage.
    admin_user, admin_password, admin_email : Informations de l'utilisateur admin par défaut.
    secret_key : Clé utilisée pour signer les cookies et les tokens.
    encryption_provider : Fournisseur de chiffrement pour les secrets.
    available_encryption_providers : Liste des fournisseurs de chiffrement disponibles.
    disable_gravatar : Désactive les images de profil Gravatar.
    data_source_proxy_whitelist : Liste des adresses IP ou domaines autorisés pour le proxy des sources de données.
    disable_brute_force_login_protection : Désactive la protection contre les tentatives de connexion par force brute.
    brute_force_login_protection_max_attempts : Nombre maximal de tentatives de connexion échouées avant de verrouiller l'utilisateur.
    cookie_secure : Active le flag Secure pour les cookies.
    cookie_samesite : Définit la politique SameSite pour les cookies.
    allow_embedding : Autorise l'intégration de Grafana dans des iframes.
    strict_transport_security : Active l'en-tête HSTS.
    strict_transport_security_max_age_seconds : Durée de validité de l'en-tête HSTS.
    strict_transport_security_preload : Active le préchargement HSTS.
    strict_transport_security_subdomains : Applique HSTS aux sous-domaines.
    x_content_type_options : Active l'en-tête X-Content-Type-Options.
    x_xss_protection : Active l'en-tête X-XSS-Protection.
    content_security_policy : Active l'en-tête Content-Security-Policy.
    content_security_policy_template : Modèle pour l'en-tête Content-Security-Policy.
    content_security_policy_report_only : Active l'en-tête Content-Security-Policy-Report-Only.
    content_security_policy_report_only_template : Modèle pour l'en-tête Content-Security-Policy-Report-Only.
    angular_support_enabled : Active le support des anciens plugins Angular.
    csrf_trusted_origins : Liste des origines de confiance pour la vérification CSRF.
    csrf_additional_headers : En-têtes supplémentaires à inclure dans la vérification CSRF.
    csrf_always_check : Effectue toujours la vérification CSRF, même si le cookie de session est absent.
    enable_frontend_sandbox_for_plugins : Liste des IDs de plugins à exécuter dans le bac à sable frontend.
    actions_allow_post_url : Liste des URLs autorisées pour les actions POST.

Section [security.encryption]

    data_keys_cache_ttl : Durée de vie des clés de chiffrement des données dans le cache.
    data_keys_cache_cleanup_interval : Intervalle de nettoyage des clés de chiffrement des données dans le cache.

Section [snapshots]

    enabled : Active la fonctionnalité de snapshots.
    external_enabled : Active les snapshots externes.
    external_snapshot_url : URL pour les snapshots externes.
    external_snapshot_name : Nom des snapshots externes.
    public_mode : Active le mode public pour les snapshots.

Section [dashboards]

    versions_to_keep : Nombre de versions de tableau de bord à conserver par tableau de bord.
    min_refresh_interval : Intervalle de rafraîchissement minimal pour les tableaux de bord.
    default_home_dashboard_path : Chemin vers le tableau de bord d'accueil par défaut.

Section [datasources]

    datasource_limit : Limite supérieure du nombre de sources de données retournées par l'API.
    concurrent_query_count : Nombre de requêtes concurrentes pour les sources de données supportant la concurrence.
    default_manage_alerts_ui_toggle : Valeur par défaut pour le paramètre "Gérer les alertes via l'interface Alerting" lors de la configuration d'une source de données.

Section [sql_datasources]

    max_open_conns_default : Nombre maximal de connexions ouvertes maintenues dans le pool de connexions pour les sources de données SQL.
    max_idle_conns_default : Nombre maximal de connexions inactives maintenues dans le pool de connexions pour les sources de données SQL.
    max_conn_lifetime_default : Durée de vie maximale des connexions pour les sources de données SQL.

Section [users]

    allow_sign_up : Autorise l'inscription des utilisateurs.
    allow_org_create : Autorise les utilisateurs non-admin à créer des organisations.
    auto_assign_org : Assigne automatiquement les nouveaux utilisateurs à l'organisation par défaut.
    auto_assign_org_id : ID de l'organisation à laquelle les nouveaux utilisateurs sont assignés automatiquement.
    auto_assign_org_role : Rôle par défaut assigné aux nouveaux utilisateurs.
    verify_email_enabled : Active la vérification des emails pour les nouveaux utilisateurs.
    login_default_org_id : ID de l'organisation par défaut après la connexion.
    login_hint, password_hint : Texte d'aide pour les champs de connexion.
    default_theme : Thème par défaut pour les nouveaux utilisateurs.
    default_language : Langue par défaut pour les nouveaux utilisateurs.
    home_page : Chemin vers une page d'accueil personnalisée.
    external_manage_link_url, external_manage_link_name, external_manage_info : Paramètres pour les liens de gestion externe des utilisateurs.
    viewers_can_edit : Autorise les viewers à modifier les paramètres des tableaux de bord.
    editors_can_admin : Autorise les éditeurs à administrer les tableaux de bord, dossiers et équipes qu'ils créent.
    user_invite_max_lifetime_duration : Durée de validité des invitations utilisateur.
    verification_email_max_lifetime_duration : Durée de validité des emails de vérification.
    last_seen_update_interval : Intervalle de mise à jour de l'heure de dernière connexion des utilisateurs.
    hidden_users : Liste des utilisateurs masqués dans l'interface utilisateur.

Section [secretscan]

    enabled : Active la fonctionnalité de scan des secrets.
    interval : Intervalle de vérification des fuites de tokens.
    base_url : URL de base du service de vérification des fuites de tokens.
    oncall_url : URL pour envoyer des webhooks en cas de détection de fuite.
    revoke : Révoque le token en cas de détection de fuite.

Section [service_accounts]

    token_expiration_day_limit : Limite maximale de durée de validité des tokens de service.

Section [auth]

    login_cookie_name : Nom du cookie de session.
    disable_login : Désactive la page de connexion intégrée de Grafana.
    login_maximum_inactive_lifetime_duration : Durée maximale d'inactivité avant de demander une nouvelle connexion.
    login_maximum_lifetime_duration : Durée maximale de validité de la session utilisateur.
    token_rotation_interval_minutes : Intervalle de rotation des tokens d'authentification.
    disable_login_form : Désactive le formulaire de connexion.
    disable_signout_menu : Désactive le lien de déconnexion dans le menu.
    signout_redirect_url : URL de redirection après la déconnexion.
    oauth_auto_login : Active la connexion automatique avec OAuth.
    oauth_login_error_message : Message d'erreur personnalisé pour les erreurs de connexion OAuth.
    oauth_state_cookie_max_age : Durée de validité du cookie d'état OAuth.
    oauth_refresh_token_server_lock_min_wait_ms : Délai d'attente minimal pour le verrou de serveur de token OAuth.
    api_key_max_seconds_to_live : Durée de validité maximale des clés API.
    sigv4_auth_enabled : Active l'authentification SigV4 pour les sources de données HTTP.
    sigv4_verbose_logging : Active la journalisation détaillée pour SigV4.
    azure_auth_enabled : Active l'authentification Azure pour les sources de données HTTP.
    oauth_allow_insecure_email_lookup : Autorise la recherche d'email insecure avec OAuth.
    id_response_header_enabled : Active l'en-tête de réponse ID.
    id_response_header_prefix : Préfixe pour l'en-tête de réponse ID.
    id_response_header_namespaces : Espaces de noms pour les en-têtes de réponse ID.
    managed_service_accounts_enabled : Active l'utilisation des comptes de service managés pour l'authentification des plugins.

Section [auth.anonymous]

    enabled : Active l'accès anonyme.
    org_name : Nom de l'organisation pour les utilisateurs anonymes.
    org_role : Rôle pour les utilisateurs anonymes.
    hide_version : Masque la version de Grafana pour les utilisateurs anonymes.
    device_limit : Limite le nombre d'appareils pour les utilisateurs anonymes.

Section [auth.github]

    name, icon, enabled, allow_sign_up, auto_login, client_id, client_secret, scopes, auth_url, token_url, api_url, signout_redirect_url, allowed_domains, team_ids, allowed_organizations, role_attribute_path, role_attribute_strict, org_mapping, allow_assign_grafana_admin, skip_org_role_sync, tls_skip_verify_insecure, tls_client_cert, tls_client_key, tls_client_ca, use_refresh_token : Paramètres pour l'authentification GitHub.

Section [auth.gitlab]

    name, icon, enabled, allow_sign_up, auto_login, client_id, client_secret, scopes, auth_url, token_url, api_url, signout_redirect_url, allowed_domains, allowed_groups, role_attribute_path, role_attribute_strict, org_mapping, allow_assign_grafana_admin, skip_org_role_sync, tls_skip_verify_insecure, tls_client_cert, tls_client_key, tls_client_ca, use_pkce, use_refresh_token : Paramètres pour l'authentification GitLab.

Section [auth.google]

    name, icon, enabled, allow_sign_up, auto_login, client_id, client_secret, scopes, auth_url, token_url, api_url, signout_redirect_url, allowed_domains, validate_hd, hosted_domain, allowed_groups, role_attribute_path, role_attribute_strict, org_mapping, allow_assign_grafana_admin, skip_org_role_sync, tls_skip_verify_insecure, tls_client_cert, tls_client_key, tls_client_ca, use_pkce, use_refresh_token : Paramètres pour l'authentification Google.

Section [auth.grafana_com]

    name, icon, enabled, allow_sign_up, auto_login, client_id, client_secret, scopes, allowed_organizations, skip_org_role_sync, use_refresh_token : Paramètres pour l'authentification Grafana.com.

Section [auth.azuread]

    name, icon, enabled, allow_sign_up, auto_login, client_authentication, client_id, client_secret, managed_identity_client_id, federated_credential_audience, scopes, auth_url, token_url, signout_redirect_url, allowed_domains, allowed_groups, allowed_organizations, role_attribute_strict, org_mapping, allow_assign_grafana_admin, skip_org_role_sync, use_refresh_token : Paramètres pour l'authentification Azure AD.

Section [auth.okta]

    name, icon, enabled, allow_sign_up, auto_login, client_id, client_secret, scopes, auth_url, token_url, api_url, signout_redirect_url, allowed_domains, allowed_groups, role_attribute_path, role_attribute_strict, org_attribute_path, org_mapping, allow_assign_grafana_admin, skip_org_role_sync, tls_skip_verify_insecure, tls_client_cert, tls_client_key, tls_client_ca, use_pkce, use_refresh_token : Paramètres pour l'authentification Okta.

Section [auth.generic_oauth]

    name, icon, enabled, allow_sign_up, auto_login, client_id, client_secret, scopes, empty_scopes, email_attribute_name, email_attribute_path, login_attribute_path, name_attribute_path, role_attribute_path, role_attribute_strict, groups_attribute_path, id_token_attribute_name, team_ids_attribute_path, auth_url, token_url, api_url, signout_redirect_url, teams_url, allowed_domains, team_ids, allowed_organizations, org_attribute_path, org_mapping, team_ids_attribute_path, tls_skip_verify_insecure, tls_client_cert, tls_client_key, tls_client_ca, use_pkce, auth_style, allow_assign_grafana_admin, skip_org_role_sync, use_refresh_token : Paramètres pour l'authentification OAuth générique.

Section [auth.basic]

    enabled : Active l'authentification de base.
    password_policy : Active la politique de mot de passe.

Section [auth.proxy]

    enabled : Active l'authentification proxy.
    header_name : Nom de l'en-tête contenant le nom d'utilisateur.
    header_property : Propriété de l'en-tête à utiliser comme nom d'utilisateur.
    auto_sign_up : Active l'inscription automatique des nouveaux utilisateurs.
    sync_ttl : Intervalle de synchronisation des utilisateurs.
    whitelist : Liste blanche des adresses IP autorisées.
    headers : En-têtes supplémentaires à extraire.
    headers_encoded : Indique si les en-têtes sont encodés.
    enable_login_token : Active les tokens de connexion.

Section [auth.jwt]

    enabled : Active l'authentification JWT.
    enable_login_token : Active les tokens de connexion.
    header_name : Nom de l'en-tête contenant le JWT.
    email_claim : Claim utilisé pour extraire l'email.
    username_claim : Claim utilisé pour extraire le nom d'utilisateur.
    email_attribute_path : Chemin pour extraire l'email.
    username_attribute_path : Chemin pour extraire le nom d'utilisateur.
    jwk_set_url : URL du set de clés JWK.
    jwk_set_file : Fichier contenant le set de clés JWK.
    cache_ttl : Durée de vie du cache des clés JWK.
    expect_claims : Claims attendus dans le JWT.
    key_file : Fichier contenant la clé privée pour signer les JWT.
    key_id : ID de la clé utilisée pour signer les JWT.
    role_attribute_path : Chemin pour extraire le rôle.
    role_attribute_strict : Indique si le rôle doit être strictement vérifié.
    groups_attribute_path : Chemin pour extraire les groupes.
    auto_sign_up : Active l'inscription automatique des nouveaux utilisateurs.
    url_login : Active la redirection vers l'URL de connexion.
    allow_assign_grafana_admin : Autorise l'assignation du rôle admin Grafana.
    skip_org_role_sync : Désactive la synchronisation des rôles d'organisation.
    signout_redirect_url : URL de redirection après la déconnexion.

Section [auth.ldap]

    enabled : Active l'authentification LDAP.
    config_file : Chemin vers le fichier de configuration LDAP.
    allow_sign_up : Active l'inscription automatique des nouveaux utilisateurs.
    skip_org_role_sync : Désactive la synchronisation des rôles d'organisation.
    sync_cron : Planification de la synchronisation LDAP.
    active_sync_enabled : Active la synchronisation active des utilisateurs LDAP.

Section [aws]

    allowed_auth_providers : Liste des fournisseurs d'authentification AWS autorisés.
    assume_role_enabled : Active l'utilisation de rôles assumés pour les sources de données AWS.
    list_metrics_page_limit : Limite le nombre de pages de métriques retournées par l'API ListMetricPages.
    external_id : ID externe pour les rôles assumés.
    session_duration : Durée de la session pour les rôles assumés.
    forward_settings_to_plugins : Liste des plugins auxquels les paramètres AWS sont transmis.

Section [azure]

    cloud : Environnement cloud Azure.
    clouds_config : Configuration personnalisée des environnements cloud Azure.
    managed_identity_enabled : Active l'utilisation des identités managées pour l'authentification Azure.
    managed_identity_client_id : ID client pour les identités managées.
    workload_identity_enabled : Active l'authentification Workload Identity pour les sources de données Azure.
    workload_identity_tenant_id : ID de tenant pour Workload Identity.
    workload_identity_client_id : ID client pour Workload Identity.
    workload_identity_token_file : Chemin vers le fichier de token pour Workload Identity.
    user_identity_enabled : Active l'authentification utilisateur pour les sources de données Azure.
    user_identity_fallback_credentials_enabled : Active les informations d'identification de secours pour les requêtes initiées par le backend.
    user_identity_token_url : URL pour obtenir le token utilisateur.
    user_identity_client_id : ID client pour l'authentification utilisateur.
    user_identity_client_secret : Secret client pour l'authentification utilisateur.
    username_assertion : Active l'assertion du nom d'utilisateur pour les authentifications proxy.
    forward_settings_to_plugins : Liste des plugins auxquels les paramètres Azure sont transmis.
    azure_entra_password_credentials_enabled : Active l'utilisation des informations d'identification de mot de passe Entra pour les sources de données MSSQL.

Section [role-based Access Control]

    permission_cache : Active le cache des permissions.
    reset_basic_roles_permissions : Réinitialise les permissions des rôles de base au démarrage.
    permission_validation_enabled : Active la validation des permissions lors de la création ou de la mise à jour des rôles.

Section [smtp]

    enabled : Active l'envoi d'emails via SMTP.
    host : Hôte SMTP.
    user : Nom d'utilisateur SMTP.
    password : Mot de passe SMTP.
    cert_file, key_file : Chemins vers les fichiers de certificat et de clé pour SMTP.
    skip_verify : Désactive la vérification du certificat SMTP.
    from_address : Adresse email de l'expéditeur.
    from_name : Nom de l'expéditeur.
    ehlo_identity : Identité EHLO pour SMTP.
    startTLS_policy : Politique StartTLS pour SMTP.
    enable_tracing : Active le traçage des emails envoyés.

Section [smtp.static_headers]

    Foo-Header, Foo : En-têtes statiques ajoutés à tous les emails envoyés.

Section [emails]

    welcome_email_on_sign_up : Envoie un email de bienvenue aux nouveaux utilisateurs.
    templates_pattern : Modèle des emails envoyés.
    content_types : Types de contenu des emails envoyés.

Section [log]

    mode : Mode de journalisation (console, file, syslog).
    level : Niveau de journalisation (debug, info, warn, error, critical).
    filters : Filtres de journalisation pour des loggers spécifiques.
    user_facing_default_error : Message d'erreur par défaut affiché aux utilisateurs.

Section [log.console]

    level : Niveau de journalisation pour la console.
    format : Format des logs pour la console.

Section [log.file]

    level : Niveau de journalisation pour les fichiers.
    format : Format des logs pour les fichiers.
    log_rotate : Active la rotation automatique des fichiers de log.
    max_lines : Nombre maximal de lignes par fichier de log.
    max_size_shift : Taille maximale des fichiers de log.
    daily_rotate : Active la rotation quotidienne des fichiers de log.
    max_days : Nombre de jours avant la suppression des fichiers de log.

Section [log.syslog]

    level : Niveau de journalisation pour syslog.
    format : Format des logs pour syslog.
    network : Type de réseau pour syslog (udp, tcp, unix).
    address : Adresse pour syslog.
    facility : Facility pour syslog.
    tag : Tag pour syslog.

Section [log.frontend]

    enabled : Active la journalisation frontend.
    custom_endpoint : Point de terminaison personnalisé pour les logs frontend.
    id_response_header_enabled : Active l'en-tête de réponse ID pour les logs frontend.
    id_response_header_prefix : Préfixe pour l'en-tête de réponse ID pour les logs frontend.
    id_response_header_namespaces : Espaces de noms pour les en-têtes de réponse ID pour les logs frontend.
    instrumentations_all_enabled : Active toutes les instrumentations pour les logs frontend.
    instrumentations_errors_enabled : Active l'instrumentation des erreurs pour les logs frontend.
    instrumentations_console_enabled : Active l'instrumentation de la console pour les logs frontend.
    instrumentations_webvitals_enabled : Active l'instrumentation des web vitals pour les logs frontend.
    instrumentations_tracing_enabled : Active l'instrumentation du traçage pour les logs frontend.
    api_key : Clé API pour les logs frontend.

Section [metrics]

    enabled : Active les métriques internes de Grafana.
    interval_seconds : Intervalle de publication des métriques internes.
    disable_total_stats : Désactive les métriques totales.
    total_stats_collector_interval_seconds : Intervalle de collecte des métriques totales.
    basic_auth_username, basic_auth_password : Informations d'identification pour l'authentification de base des métriques internes.

Section [metrics.environment_info]

    exampleLabel1, exampleLabel2 : Informations d'environnement ajoutées aux métriques internes.

Section [metrics.graphite]

    address : Adresse Graphite pour les métriques internes.
    prefix : Préfixe pour les métriques Graphite.

Section [grafana_com]

    url : URL pour importer des tableaux de bord depuis Grafana.com.
    api_url : URL de l'API Grafana.com.
    sso_api_token : Token API pour l'intégration SSO avec Grafana.com.

Section [distributed tracing]

    tracing.jaeger.address : Adresse Jaeger pour le traçage distribué.
    tracing.jaeger.always_included_tag : Tag toujours inclus dans les spans Jaeger.
    tracing.jaeger.sampler_type : Type de sampler Jaeger.
    tracing.jaeger.sampler_param : Paramètre de sampler Jaeger.
    tracing.jaeger.sampling_server_url : URL du serveur de sampling Jaeger.
    tracing.jaeger.zipkin_propagation : Active la propagation Zipkin pour Jaeger.
    tracing.jaeger.disable_shared_zipkin_spans : Désactive les spans Zipkin partagés pour Jaeger.

Section [tracing.opentelemetry]

    custom_attributes : Attributs personnalisés ajoutés aux spans OpenTelemetry.
    sampler_type : Type de sampler OpenTelemetry.
    sampler_param : Paramètre de sampler OpenTelemetry.
    sampling_server_url : URL du serveur de sampling OpenTelemetry.

Section [tracing.opentelemetry.jaeger]

    address : Adresse Jaeger pour OpenTelemetry.
    propagation : Format de propagation pour OpenTelemetry Jaeger.

Section [tracing.opentelemetry.otlp]

    address : Adresse OTLP pour OpenTelemetry.
    propagation : Format de propagation pour OpenTelemetry OTLP.

Section [external_image_storage]

    provider : Fournisseur de stockage d'images externe (s3, webdav, gcs, azure_blob, local).

Section [external_image_storage.s3]

    endpoint, path_style_access, bucket, region, path, access_key, secret_key : Paramètres pour le stockage d'images sur S3.

Section [external_image_storage.webdav]

    url, username, password, public_url : Paramètres pour le stockage d'images sur WebDAV.

Section [external_image_storage.gcs]

    key_file, bucket, path, enable_signed_urls, signed_url_expiration : Paramètres pour le stockage d'images sur GCS.

Section [external_image_storage.azure_blob]

    account_name, account_key, container_name, sas_token_expiration_days : Paramètres pour le stockage d'images sur Azure Blob.

Section [external_image_storage.local]

    N/A : Pas de configuration nécessaire pour le stockage local.

Section [rendering]

    server_url : URL du service de rendu d'images.
    callback_url : URL de callback pour le service de rendu d'images.
    renderer_token : Token d'authentification pour le service de rendu d'images.
    concurrent_render_request_limit : Limite de requêtes de rendu concurrentes.
    render_key_lifetime : Durée de vie de la clé de rendu.
    default_image_width, default_image_height, default_image_scale : Dimensions et échelle par défaut pour les images rendues.

Section [panels]

    disable_sanitize_html : Désactive la désinfection HTML dans les panneaux de texte.

Section [plugins]

    enable_alpha : Active les plugins en version alpha.
    app_tls_skip_verify_insecure : Désactive la vérification TLS pour les plugins.
    allow_loading_unsigned_plugins : Autorise le chargement des plugins non signés.
    plugin_admin_enabled : Active l'administration des plugins.
    plugin_admin_external_manage_enabled : Active la gestion externe des plugins.
    plugin_catalog_url : URL du catalogue de plugins.
    plugin_catalog_hidden_plugins : Liste des plugins masqués dans le catalogue.
    log_backend_requests : Active la journalisation des requêtes backend pour les plugins.
    public_key_retrieval_disabled : Désactive la récupération de la clé publique pour la vérification des signatures des plugins.
    public_key_retrieval_on_startup : Force la récupération de la clé publique au démarrage.
    disable_plugins : Liste des plugins désactivés.

Section [live]

    max_connections : Nombre maximal de connexions WebSocket pour Grafana Live.
    allowed_origins : Origines autorisées pour les connexions WebSocket.
    ha_engine : Moteur HA pour Grafana Live.
    ha_engine_address : Adresse pour le moteur HA.
    ha_engine_password : Mot de passe pour le moteur HA.
    ha_prefix : Préfixe pour les clés dans le moteur HA.

Section [plugin.grafana-image-renderer]

    rendering_timezone : Fuseau horaire par défaut pour le rendu des images.
    rendering_language : Langue par défaut pour le rendu des images.
    rendering_viewport_device_scale_factor : Facteur d'échelle par défaut pour le rendu des images.
    rendering_ignore_https_errors : Ignore les erreurs HTTPS lors du rendu des images.
    rendering_verbose_logging : Active la journalisation détaillée pour le rendu des images.
    rendering_dumpio : Active l'affichage des messages de débogage et d'erreur dans le processus de rendu des images.
    rendering_timing_metrics : Active les métriques de timing pour le rendu des images.
    rendering_args : Arguments supplémentaires pour le rendu des images.
    rendering_chrome_bin : Chemin vers le binaire Chrome pour le rendu des images.
    rendering_mode : Mode de création des instances de navigateur pour le rendu des images.
    rendering_clustering_mode : Mode de clustering pour le rendu des images.
    rendering_clustering_max_concurrency : Nombre maximal de concurrences pour le rendu des images.
    rendering_clustering_timeout : Délai d'attente pour le rendu des images.
    rendering_viewport_max_width, rendering_viewport_max_height, rendering_viewport_max_device_scale_factor : Limites pour les dimensions et l'échelle du viewport pour le rendu des images.
    grpc_host, grpc_port : Adresse et port pour le serveur gRPC du rendu des images.

Section [enterprise]

    license_path : Chemin vers le fichier de licence Grafana Enterprise.

Section [feature_toggles]

    enable : Liste des fonctionnalités à activer.
    feature1, feature2 : Activation ou désactivation de fonctionnalités spécifiques.

Section [date_formats]

    full_date : Format de date complet utilisé dans le sélecteur de plage temporelle.
    interval_second, interval_minute, interval_hour, interval_day, interval_month, interval_year : Formats de date pour différents intervalles.
    use_browser_locale : Utilise la locale du navigateur pour les formats de date.
    default_timezone : Fuseau horaire par défaut pour les préférences utilisateur.

Section [expressions]

    enabled : Active la fonctionnalité des expressions.

Section [geomap]

    default_baselayer_config : Configuration JSON pour la couche de base par défaut des cartes géographiques.
    enable_custom_baselayers : Active le chargement d'autres couches de base pour les cartes géographiques.

Section [support_bundles]

    enabled : Active la création de bundles de support.
    server_admin_only : Seuls les admins serveur peuvent générer et voir les bundles de support.
    public_keys : Clés publiques pour chiffrer les bundles de support.

Section [navigation.app_sections]

    my-app-id : Déplace une application plugin sous une section de navigation spécifique.

Section [navigation.app_standalone_pages]

    /a/my-app-id/my-page : Déplace une page spécifique d'une application plugin sous une section de navigation spécifique.

Section [secure_socks_datasource_proxy]

    enabled : Active le proxy de datasource SOCKS5 sécurisé.
    root_ca_cert : Certificat CA racine pour le proxy SOCKS5.
    client_key, client_cert : Clé et certificat client pour le proxy SOCKS5.
    server_name : Nom du serveur pour le proxy SOCKS5.
    proxy_address : Adresse du proxy SOCKS5.
    show_ui : Affiche l'interface utilisateur pour le proxy SOCKS5.
    allow_insecure : Autorise les connexions non sécurisées pour le proxy SOCKS5.

Section [feature_management]

    allow_editing : Autorise l'édition des fonctionnalités dans la page de gestion des fonctionnalités.
    update_webhook : URL personnalisée pour le contrôleur qui gère les fonctionnalités.
    update_webhook_token : Token d'authentification pour les requêtes de mise à jour des fonctionnalités.
    hidden_toggles : Liste des fonctionnalités masquées dans la page de gestion des fonctionnalités.
    read_only_toggles : Liste des fonctionnalités en lecture seule dans la page de gestion des fonctionnalités.

Section [public_dashboards]

    enabled : Active les tableaux de bord publics.

Section [cloud_migration]

    is_target : Active l'interface de migration côté cible.
    gcom_api_token : Token API pour envoyer des requêtes à Grafana.com.
    start_snapshot_timeout, validate_key_timeout, get_snapshot_status_timeout, create_upload_url_timeout, report_event_timeout, fetch_instance_timeout, create_access_policy_timeout, fetch_access_policy_timeout, delete_access_policy_timeout : Délais d'attente pour les requêtes de migration.
    domain : Nom de domaine utilisé pour accéder à CMS.
    snapshot_folder : Dossier utilisé pour stocker les fichiers de snapshot.
    feedback_url : Lien pour donner des feedbacks sur la fonctionnalité.
    frontend_poll_interval : Intervalle de polling pour les changements pendant la migration.
    alert_rules_state : Contrôle la manière dont les règles d'alerte sont migrées.

Section [frontend_dev]

    fail_tests_on_console : Indique si les tests UI doivent échouer en cas de logs/warnings/errors dans la console.

Section [unified_alerting]

    enabled : Active le sous-système d'alerting unifié.
    disabled_orgs : Liste des IDs d'organisations pour lesquelles l'alerting unifié est désactivé.
    initialization_timeout : Délai d'attente pour l'initialisation du service d'alerting.
    admin_config_poll_interval : Intervalle de polling pour les changements de configuration admin.
    alertmanager_config_poll_interval : Intervalle de polling pour les changements de configuration Alertmanager.
    alertmanager_max_silences_count : Nombre maximal de silences actifs et en attente qu'un tenant peut avoir.
    alertmanager_max_silence_size_bytes : Taille maximale des silences en octets.
    ha_redis_cluster_mode_enabled : Indique si Redis est utilisé en mode cluster.
    ha_redis_address : Adresse du serveur Redis.
    ha_redis_username, ha_redis_password : Nom d'utilisateur et mot de passe pour Redis.
    ha_redis_db : Base de données Redis.
    ha_redis_prefix : Préfixe pour les clés Redis.
    ha_redis_peer_name : Nom du peer Redis.
    ha_redis_max_conns : Nombre maximal de connexions Redis.
    ha_redis_tls_enabled : Active TLS pour les connexions Redis.
    ha_redis_tls_cert_path, ha_redis_tls_key_path, ha_redis_tls_ca_path : Chemins vers les fichiers de certificat et de clé pour TLS Redis.
    ha_redis_tls_server_name : Nom du serveur TLS Redis.
    ha_redis_tls_insecure_skip_verify : Désactive la vérification TLS pour Redis.
    ha_redis_tls_cipher_suites : Suites de chiffrement TLS pour Redis.
    ha_redis_tls_min_version : Version minimale de TLS pour Redis.
    ha_listen_address, ha_advertise_address : Adresse d'écoute et adresse annoncée pour les messages d'alerting unifié.
    ha_peers : Liste des pairs initiaux pour le cluster HA.
    ha_peer_timeout : Délai d'attente pour les pairs HA.
    ha_label : Label pour le cluster HA.
    ha_gossip_interval : Intervalle entre les messages gossip.
    ha_reconnect_timeout : Délai d'attente pour la reconnexion aux pairs perdus.
    ha_push_pull_interval : Intervalle pour les synchronisations complètes d'état.
    execute_alerts : Active l'exécution des alertes.
    evaluation_timeout : Délai d'attente pour l'évaluation des alertes.
    max_attempts : Nombre maximal de tentatives pour évaluer une alerte.
    min_interval : Intervalle minimal entre les évaluations des alertes.
    max_state_save_concurrency : Nombre maximal de requêtes concurrentes pour sauvegarder l'état des alertes.
    state_periodic_save_interval : Intervalle pour sauvegarder périodiquement l'état des alertes.
    state_periodic_save_batch_size : Taille du batch pour sauvegarder périodiquement l'état des alertes.
    disable_jitter : Désactive le lissage des évaluations des alertes.
    resolved_alert_retention : Durée pendant laquelle les alertes résolues continuent d'être envoyées à Alertmanager.
    rule_version_record_limit : Nombre de versions de règles d'alerte à conserver.

Section [unified_alerting.screenshots]

    capture : Active la capture des captures d'écran pour les notifications.
    capture_timeout : Délai d'attente pour capturer les captures d'écran.
    max_concurrent_screenshots : Nombre maximal de captures d'écran concurrentes.
    upload_external_image_storage : Télécharge les captures d'écran vers le stockage d'images externe.

Section [unified_alerting.reserved_labels]

    disabled_labels : Liste des labels réservés désactivés pour l'alerting unifié.

Section [unified_alerting.state_history]

    enabled : Active la fonctionnalité d'historique d'état pour l'alerting unifié.
    backend : Backend utilisé pour stocker l'historique d'état.
    primary : Backend principal utilisé pour servir les requêtes d'historique d'état.
    secondaries : Backends secondaires utilisés pour stocker l'historique d'état.
    loki_remote_url, loki_remote_read_url, loki_remote_write_url : URLs pour le backend Loki.
    loki_tenant_id : ID de tenant pour le backend Loki.
    loki_basic_auth_username, loki_basic_auth_password : Informations d'identification pour le backend Loki.
    loki_max_query_length : Durée maximale des requêtes pour le backend Loki.
    loki_max_query_size : Taille maximale des requêtes pour le backend Loki.

Section [unified_alerting.state_history.external_labels]

    mylabelkey : Labels supplémentaires ajoutés aux enregistrements d'historique d'état.

Section [recording_rules]

    enabled : Active les règles d'enregistrement.
    url : URL cible pour les règles d'enregistrement.
    basic_auth_username, basic_auth_password : Informations d'identification pour les règles d'enregistrement.
    timeout : Délai d'attente pour les écritures des règles d'enregistrement.
    custom_headers : En-têtes personnalisés pour les requêtes d'écriture des règles d'enregistrement.

Section [annotations]

    cleanupjob_batchsize : Taille du batch pour le nettoyage des annotations.
    tags_length : Longueur maximale des tags pour les annotations.

Section [annotations.dashboard]

    max_age : Durée de conservation des annotations de tableau de bord.
    max_annotations_to_keep : Nombre maximal d'annotations de tableau de bord à conserver.

Section [annotations.api]

    max_age : Durée de conservation des annotations API.
    max_annotations_to_keep : Nombre maximal d'annotations API à conserver.

Section [explore]

    enabled : Active la section Explore.

Section [help]

    enabled : Active la section Help.

Section [profile]

    enabled : Active la section Profile.

Section [news]

    news_feed_enabled : Active le flux de news.

Section [query]

    concurrent_query_limit : Nombre de requêtes de source de données concurrentes dans les requêtes mixtes.

Section [query_history]

    enabled : Active l'historique des requêtes.

Section [short_links]

    expire_time : Durée de conservation des short links non utilisés.

Section [internal_grafana_metrics]

    enabled : Active les métriques internes de Grafana.
    interval_seconds : Intervalle de publication des métriques internes.
    disable_total_stats : Désactive les métriques totales.
    total_stats_collector_interval_seconds : Intervalle de collecte des métriques totales.
    basic_auth_username, basic_auth_password : Informations d'identification pour l'authentification de base des métriques internes.

Section [metrics.environment_info]

    exampleLabel1, exampleLabel2 : Informations d'environnement ajoutées aux métriques internes.

Section [metrics.graphite]

    address : Adresse Graphite pour les métriques internes.
    prefix : Préfixe pour les métriques Graphite.

Section [tracing.jaeger]

    address : Adresse Jaeger pour le traçage distribué.
    always_included_tag : Tag toujours inclus dans les spans Jaeger.
    sampler_type : Type de sampler Jaeger.
    sampler_param : Paramètre de sampler Jaeger.
    sampling_server_url : URL du serveur de sampling Jaeger.
    zipkin_propagation : Active la propagation Zipkin pour Jaeger.
    disable_shared_zipkin_spans : Désactive les spans Zipkin partagés pour Jaeger.

Section [tracing.opentelemetry]

    custom_attributes : Attributs personnalisés ajoutés aux spans OpenTelemetry.
    sampler_type : Type de sampler OpenTelemetry.
    sampler_param : Paramètre de sampler OpenTelemetry.
    sampling_server_url : URL du serveur de sampling OpenTelemetry.

Section [tracing.opentelemetry.jaeger]

    address : Adresse Jaeger pour OpenTelemetry.
    propagation : Format de propagation pour OpenTelemetry Jaeger.

Section [tracing.opentelemetry.otlp]

    address : Adresse OTLP pour OpenTelemetry.
    propagation : Format de propagation pour OpenTelemetry OTLP.

Section [external_image_storage]

    provider : Fournisseur de stockage d'images externe (s3, webdav, gcs, azure_blob, local).

Section [external_image_storage.s3]

    endpoint, path_style_access, bucket, region, path, access_key, secret_key : Paramètres pour le stockage d'images sur S3.

Section [external_image_storage.webdav]

    url, username, password, public_url : Paramètres pour le stockage d'images sur WebDAV.

Section [external_image_storage.gcs]

    key_file, bucket, path, enable_signed_urls, signed_url_expiration : Paramètres pour le stockage d'images sur GCS.

Section [external_image_storage.azure_blob]

    account_name, account_key, container_name, sas_token_expiration_days : Paramètres pour le stockage d'images sur Azure Blob.

Section [external_image_storage.local]

    N/A : Pas de configuration nécessaire pour le stockage local.

Section [rendering]

    server_url : URL du service de rendu d'images.
    callback_url : URL de callback pour le service de rendu d'images.
    renderer_token : Token d'authentification pour le service de rendu d'images.
    concurrent_render_request_limit : Limite de requêtes de rendu concurrentes.
    render_key_lifetime : Durée de vie de la clé de rendu.
    default_image_width, default_image_height, default_image_scale : Dimensions et échelle par défaut pour les images rendues.

Section [panels]

    disable_sanitize_html : Désactive la désinfection HTML dans les panneaux de texte.

Section [plugins]

    enable_alpha : Active les plugins en version alpha.
    app_tls_skip_verify_insecure : Désactive la vérification TLS pour les plugins.
    allow_loading_unsigned_plugins : Autorise le chargement des plugins non signés.
    plugin_admin_enabled : Active l'administration des plugins.
    plugin_admin_external_manage_enabled : Active la gestion externe des plugins.
    plugin_catalog_url : URL du catalogue de plugins.
    plugin_catalog_hidden_plugins : Liste des plugins masqués dans le catalogue.
    log_backend_requests : Active la journalisation des requêtes backend pour les plugins.
    public_key_retrieval_disabled : Désactive la récupération de la clé publique pour la vérification des signatures des plugins.
    public_key_retrieval_on_startup : Force la récupération de la clé publique au démarrage.
    disable_plugins : Liste des plugins désactivés.

Section [live]

    max_connections : Nombre maximal de connexions WebSocket pour Grafana Live.
    allowed_origins : Origines autorisées pour les connexions WebSocket.
    ha_engine : Moteur HA pour Grafana Live.
    ha_engine_address : Adresse pour le moteur HA.
    ha_engine_password : Mot de passe pour le moteur HA.
    ha_prefix : Préfixe pour les clés dans le moteur HA.

Section [plugin.grafana-image-renderer]

    rendering_timezone : Fuseau horaire par défaut pour le rendu des images.
    rendering_language : Langue par défaut pour le rendu des images.
    rendering_viewport_device_scale_factor : Facteur d'échelle par défaut pour le rendu des images.
    rendering_ignore_https_errors : Ignore les erreurs HTTPS lors du rendu des images.
    rendering_verbose_logging : Active la journalisation détaillée pour le rendu des images.
    rendering_dumpio : Active l'affichage des messages de débogage et d'erreur dans le processus de rendu des images.
    rendering_timing_metrics : Active les métriques de timing pour le rendu des images.
    rendering_args : Arguments supplémentaires pour le rendu des images.
    rendering_chrome_bin : Chemin vers le binaire Chrome pour le rendu des images.
    rendering_mode : Mode de création des instances de navigateur pour le rendu des images.
    rendering_clustering_mode : Mode de clustering pour le rendu des images.
    rendering_clustering_max_concurrency : Nombre maximal de concurrences pour le rendu des images.
    rendering_clustering_timeout : Délai d'attente pour le rendu des images.
    rendering_viewport_max_width, rendering_viewport_max_height, rendering_viewport_max_device_scale_factor : Limites pour les dimensions et l'échelle du viewport pour le rendu des images.
    grpc_host, grpc_port : Adresse et port pour le serveur gRPC du rendu des images.

Section [enterprise]

    license_path : Chemin vers le fichier de licence Grafana Enterprise.

Section [feature_toggles]

    enable : Liste des fonctionnalités à activer.
    feature1, feature2 : Activation ou désactivation de fonctionnalités spécifiques.

Section [date_formats]

    full_date : Format de date complet utilisé dans le sélecteur de plage temporelle.
    interval_second, interval_minute, interval_hour, interval_day, interval_month, interval_year : Formats de date pour différents intervalles.
    use_browser_locale : Utilise la locale du navigateur pour les formats de date.
    default_timezone : Fuseau horaire par défaut pour les préférences utilisateur.

Section [expressions]

    enabled : Active la fonctionnalité des expressions.

Section [geomap]

    default_baselayer_config : Configuration JSON pour la couche de base par défaut des cartes géographiques.
    enable_custom_baselayers : Active le chargement d'autres couches de base pour les cartes géographiques.

Section [support_bundles]

    enabled : Active la création de bundles de support.
    server_admin_only : Seuls les admins serveur peuvent générer et voir les bundles de support.
    public_keys : Clés publiques pour chiffrer les bundles de support.

Section [navigation.app_sections]

    my-app-id : Déplace une application plugin sous une section de navigation spécifique.

Section [navigation.app_standalone_pages]

    /a/my-app-id/my-page : Déplace une page spécifique d'une application plugin sous une section de navigation spécifique.

Section [secure_socks_datasource_proxy]

    enabled : Active le proxy de datasource SOCKS5 sécurisé.
    root_ca_cert : Certificat CA racine pour le proxy SOCKS5.
    client_key, client_cert : Clé et certificat client pour le proxy SOCKS5.
    server_name : Nom du serveur pour le proxy SOCKS5.
    proxy_address : Adresse du proxy SOCKS5.
    show_ui : Affiche l'interface utilisateur pour le proxy SOCKS5.
    allow_insecure : Autorise les connexions non sécurisées pour le proxy SOCKS5.

Section [feature_management]

    allow_editing : Autorise l'édition des fonctionnalités dans la page de gestion des fonctionnalités.
    update_webhook : URL personnalisée pour le contrôleur qui gère les fonctionnalités.
    update_webhook_token : Token d'authentification pour les requêtes de mise à jour des fonctionnalités.
    hidden_toggles : Liste des fonctionnalités masquées dans la page de gestion des fonctionnalités.
    read_only_toggles : Liste des fonctionnalités en lecture seule dans la page de gestion des fonctionnalités.

Section [public_dashboards]

    enabled : Active les tableaux de bord publics.

Section [cloud_migration]

    is_target : Active l'interface de migration côté cible.
    gcom_api_token : Token API pour envoyer des requêtes à Grafana.com.
    start_snapshot_timeout, validate_key_timeout, get_snapshot_status_timeout, create_upload_url_timeout, report_event_timeout, fetch_instance_timeout, create_access_policy_timeout, fetch_access_policy_timeout, delete_access_policy_timeout : Délais d'attente pour les requêtes de migration.
    domain : Nom de domaine utilisé pour accéder à CMS.
    snapshot_folder : Dossier utilisé pour stocker les fichiers de snapshot.
    feedback_url : Lien pour donner des feedbacks sur la fonctionnalité.
    frontend_poll_interval : Intervalle de polling pour les changements pendant la migration.
    alert_rules_state : Contrôle la manière dont les règles d'alerte sont migrées.

Section [frontend_dev]

    fail_tests_on_console : Indique si les tests UI doivent échouer en cas de logs/warnings/errors dans la console.
