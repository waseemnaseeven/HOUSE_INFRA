# AppRole Integration — Design Spec
Date: 2026-04-14

## Context

Single-node Vault on Lightsail (Ubuntu/systemd), KV v2, auto-unseal AWS KMS.
Ansible est le seul consommateur d'AppRole. L'objectif est de remplacer les tokens statiques
par des tokens éphémères (TTL 1h) générés via AppRole à chaque run.

## Objectif

Éliminer tout token statique Vault dans les vars Ansible. Chaque run obtient un token
frais via AppRole login, qui expire automatiquement après 1h.

## Architecture

### Premier run (bootstrap)

```
init.yml      → vault_root_token (fact en mémoire, depuis init response)
kv.yml        → KV v2 + audit activés (inchangé)
approle.yml   → policy "ansible-admin" uploadée
              → AppRole auth method activé
              → rôle "ansible" créé
              → role_id lu + sauvegardé dans vault-backup/lightsail1/
              → secret_id généré + sauvegardé dans vault-backup/lightsail1/
```

L'opérateur copie ensuite `role_id` et `secret_id` dans
`inventory/host_vars/lightsail1/vault_secrets.yml` (chiffré ansible-vault).

### Re-runs suivants

```
vault_secrets.yml  →  vault_approle_role_id + vault_approle_secret_id (chiffrés)
main.yml (pre)     →  AppRole login → vault_root_token éphémère (TTL 1h)
kv.yml             →  idempotent, skip si déjà configuré
approle.yml        →  idempotent, skip si déjà configuré
```

## Composants

### `tasks/approle.yml` (nouveau)

Tâches dans l'ordre, toutes idempotentes :

1. **Upload policy** — `vault policy write ansible-admin` via API PUT `/v1/sys/policies/acl/ansible-admin`
2. **Check AppRole enabled** — GET `/v1/sys/auth` → chercher `approle/`
3. **Enable AppRole** — POST `/v1/sys/auth/approle` si absent
4. **Create/update role** — POST `/v1/auth/approle/role/ansible` avec les paramètres de TTL
5. **Read role_id** — GET `/v1/auth/approle/role/ansible/role-id`
6. **Generate secret_id** — POST `/v1/auth/approle/role/ansible/secret-id`
   - Protégé par un fichier sentinel local (`vault-backup/lightsail1/.approle_bootstrapped`)
   - Si le sentinel existe → skip la génération (évite de casser le secret_id en cours)
7. **Sauvegarder** role_id + secret_id dans `vault-backup/lightsail1/`
8. **Afficher instructions** — dire à l'opérateur d'ajouter les credentials dans vault_secrets.yml

### Login AppRole dans `tasks/main.yml`

Ajouté avant les includes existants :

```yaml
- name: AppRole login (re-runs)
  ansible.builtin.uri:
    url: "{{ vault_local_api_url }}/v1/auth/approle/login"
    method: POST
    validate_certs: false
    body_format: json
    body:
      role_id: "{{ vault_approle_role_id }}"
      secret_id: "{{ vault_approle_secret_id }}"
  register: approle_login
  when:
    - vault_approle_role_id != ''
    - vault_approle_secret_id != ''

- name: Set vault_root_token from AppRole login
  ansible.builtin.set_fact:
    vault_root_token: "{{ approle_login.json.auth.client_token }}"
  when: approle_login is not skipped
```

### `defaults/main.yml` — nouvelles variables

```yaml
vault_approle_enabled: true
vault_approle_role_name: "ansible"
vault_approle_policy_name: "ansible-admin"
vault_approle_token_ttl: "1h"
vault_approle_token_max_ttl: "2h"
vault_approle_secret_id_ttl: "0"       # pas d'expiration
vault_approle_secret_id_num_uses: 0    # usage illimité
vault_approle_role_id: ""              # override dans vault_secrets.yml
vault_approle_secret_id: ""            # override dans vault_secrets.yml
```

### Policy `files/admin.hcl`

Réutilisée telle quelle, renommée logiquement en `ansible-admin` lors de l'upload.

### `host_vars/lightsail1/vault_secrets.yml`

Après bootstrap, l'opérateur ajoute :
```yaml
vault_approle_role_id: "<uuid-depuis-vault-backup>"
vault_approle_secret_id: "<uuid-depuis-vault-backup>"
```

## Gestion des erreurs

| Situation | Comportement |
|-----------|-------------|
| Premier run, pas de AppRole credentials | init.yml fournit vault_root_token, AppRole bootstrappé |
| Re-run, credentials présents | AppRole login, token éphémère obtenu |
| Re-run, credentials absents ou invalides | Fail explicite avec message d'instruction |
| AppRole déjà configuré | Toutes les tâches idempotentes, rien de cassé |
| secret_id sentinel présent | Génération skippée, secret_id existant préservé |

## Fichiers modifiés

| Fichier | Type de changement |
|---------|-------------------|
| `tasks/approle.yml` | Nouveau |
| `tasks/main.yml` | Ajout login AppRole + include approle.yml |
| `defaults/main.yml` | Ajout variables AppRole |
| `inventory/host_vars/lightsail1/vault_secrets.yml` | Ajout role_id + secret_id (manuel, post-bootstrap) |

## Ce qui ne change pas

- `install.yml` — inchangé
- `init.yml` — inchangé
- `kv.yml` — inchangé
- `files/admin.hcl` — réutilisé tel quel
- `templates/` — inchangés
