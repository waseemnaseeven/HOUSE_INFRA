---
name: Vault Homelab Infrastructure
description: Architecture Vault sur Lightsail, patterns de token sharing entre rôles, stratégie de bootstrap AppRole
type: project
---

Vault tourne sur un serveur AWS Lightsail (`lightsail1`, IP `54.217.225.162`, user `ubuntu`).

- API locale : `https://127.0.0.1:8200` (évite dépendance DNS)
- TLS auto-signé — `validate_certs: false` partout
- KV v2 monté sur `secret/`
- AppRole auth activé par le rôle `vault`

**Pattern de token sharing entre rôles (clé) :**  
Le rôle `vault` expose `vault_root_token` via `set_fact` à l'init (premier run) ou via AppRole login (re-runs). Le rôle `vault_policies` le consomme directement car ils sont dans le même play (`All4One.yml`). Le fallback en cas de run isolé : lire `vault-backup/lightsail1/admin_token`, puis `--extra-vars`, sinon fail explicite.

**Sentinels d'idempotence (fichiers locaux dans vault-backup/) :**  
- `.admin_token_created` → ne recrée pas le token admin  
- `.approle_ansible_bootstrapped` → ne régénère pas le secret_id Ansible  
- `.user1_token_created` → ne recrée pas le token user1  
- `.approle_bootstrapped` → utilisé par le rôle vault (AppRole initial)

**Rôle vault_policies :**  
Créé pour gérer policies, tokens humains, et AppRole Ansible séparément du rôle vault. Tags : `policies`, `admin`, `approle`, `users`.

**Why:** Séparation des responsabilités — le rôle vault gère install/init/unsealing, vault_policies gère IAM Vault.

**How to apply:** Quand l'utilisateur ajoute de nouveaux secrets managers ou policies, travailler dans vault_policies/. Ne pas mettre de logique IAM dans le rôle vault.
