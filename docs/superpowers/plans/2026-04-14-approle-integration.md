# AppRole Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Intégrer AppRole dans le rôle Ansible Vault pour remplacer les tokens statiques par des tokens éphémères (TTL 1h) générés à chaque run.

**Architecture:** Un nouveau fichier `approle.yml` bootstrappe AppRole (policy, auth method, rôle, credentials) lors du premier run en utilisant le `vault_root_token` issu de `init.yml`. Les re-runs détectent `vault_approle_role_id` + `vault_approle_secret_id` dans `vault_secrets.yml` et les utilisent pour obtenir un token éphémère via AppRole login avant toute opération Vault.

**Tech Stack:** Ansible, HashiCorp Vault REST API, ansible-vault

---

## File Map

| Fichier | Action | Responsabilité |
|---------|--------|----------------|
| `tarnished_lab/roles/vault/defaults/main.yml` | Modify | Ajouter variables AppRole |
| `tarnished_lab/roles/vault/tasks/approle.yml` | Create | Bootstrap AppRole (policy, auth method, rôle, credentials) |
| `tarnished_lab/roles/vault/tasks/main.yml` | Modify | AppRole login pré-include + inclure approle.yml |
| `tarnished_lab/inventory/host_vars/lightsail1/vault_secrets.yml` | Modify (manuel) | Ajouter role_id + secret_id chiffrés |

---

### Task 1: Ajouter les variables AppRole dans defaults/main.yml

**Files:**
- Modify: `tarnished_lab/roles/vault/defaults/main.yml`

- [ ] **Step 1: Ajouter le bloc AppRole à la fin du fichier**

Ajouter après le bloc `# KV configuration` :

```yaml
# AppRole authentication
vault_approle_enabled: true
vault_approle_role_name: "ansible"
vault_approle_policy_name: "ansible-admin"
vault_approle_token_ttl: "1h"
vault_approle_token_max_ttl: "2h"
vault_approle_secret_id_ttl: "0"
vault_approle_secret_id_num_uses: 0
# Override these two in host_vars/lightsail1/vault_secrets.yml (ansible-vault encrypted)
vault_approle_role_id: ""
vault_approle_secret_id: ""
```

- [ ] **Step 2: Vérifier la syntaxe YAML**

```bash
python3 -c "import yaml; yaml.safe_load(open('tarnished_lab/roles/vault/defaults/main.yml'))" && echo "OK"
```

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add tarnished_lab/roles/vault/defaults/main.yml
git commit -m "feat(vault): add AppRole defaults"
```

---

### Task 2: Créer tasks/approle.yml

**Files:**
- Create: `tarnished_lab/roles/vault/tasks/approle.yml`

- [ ] **Step 1: Créer le fichier avec le contenu suivant**

```yaml
---
- name: Upload ansible-admin policy
  ansible.builtin.uri:
    url: "{{ vault_local_api_url }}/v1/sys/policies/acl/{{ vault_approle_policy_name }}"
    method: PUT
    validate_certs: false
    headers:
      X-Vault-Token: "{{ vault_root_token }}"
    body_format: json
    body:
      policy: "{{ lookup('file', role_path + '/files/admin.hcl') }}"
    status_code: [200, 204]

- name: Check which auth methods are enabled
  ansible.builtin.uri:
    url: "{{ vault_local_api_url }}/v1/sys/auth"
    method: GET
    validate_certs: false
    headers:
      X-Vault-Token: "{{ vault_root_token }}"
    status_code: [200]
  register: vault_auth_methods

- name: Enable AppRole auth method
  ansible.builtin.uri:
    url: "{{ vault_local_api_url }}/v1/sys/auth/approle"
    method: POST
    validate_certs: false
    headers:
      X-Vault-Token: "{{ vault_root_token }}"
    body_format: json
    body:
      type: "approle"
    status_code: [200, 204]
  when: "'approle/' not in vault_auth_methods.json"

- name: Create/update AppRole role
  ansible.builtin.uri:
    url: "{{ vault_local_api_url }}/v1/auth/approle/role/{{ vault_approle_role_name }}"
    method: POST
    validate_certs: false
    headers:
      X-Vault-Token: "{{ vault_root_token }}"
    body_format: json
    body:
      token_policies: ["{{ vault_approle_policy_name }}"]
      token_ttl: "{{ vault_approle_token_ttl }}"
      token_max_ttl: "{{ vault_approle_token_max_ttl }}"
      secret_id_ttl: "{{ vault_approle_secret_id_ttl }}"
      secret_id_num_uses: "{{ vault_approle_secret_id_num_uses }}"
    status_code: [200, 204]

- name: Read role_id
  ansible.builtin.uri:
    url: "{{ vault_local_api_url }}/v1/auth/approle/role/{{ vault_approle_role_name }}/role-id"
    method: GET
    validate_certs: false
    headers:
      X-Vault-Token: "{{ vault_root_token }}"
    status_code: [200]
  register: approle_role_id_response

- name: Set role_id fact
  ansible.builtin.set_fact:
    vault_fetched_role_id: "{{ approle_role_id_response.json.data.role_id }}"

- name: Check if AppRole bootstrap sentinel exists locally
  ansible.builtin.stat:
    path: "{{ playbook_dir }}/../vault-backup/{{ inventory_hostname }}/.approle_bootstrapped"
  delegate_to: localhost
  become: false
  register: approle_sentinel_stat

- name: Generate secret_id (first bootstrap only)
  ansible.builtin.uri:
    url: "{{ vault_local_api_url }}/v1/auth/approle/role/{{ vault_approle_role_name }}/secret-id"
    method: POST
    validate_certs: false
    headers:
      X-Vault-Token: "{{ vault_root_token }}"
    body_format: json
    body: {}
    status_code: [200]
  register: approle_secret_id_response
  when: not approle_sentinel_stat.stat.exists

- name: Save role_id to local backup
  ansible.builtin.copy:
    content: "{{ vault_fetched_role_id }}"
    dest: "{{ playbook_dir }}/../vault-backup/{{ inventory_hostname }}/approle_role_id"
    mode: '0600'
  delegate_to: localhost
  become: false

- name: Save secret_id to local backup
  ansible.builtin.copy:
    content: "{{ approle_secret_id_response.json.data.secret_id }}"
    dest: "{{ playbook_dir }}/../vault-backup/{{ inventory_hostname }}/approle_secret_id"
    mode: '0600'
  delegate_to: localhost
  become: false
  when: not approle_sentinel_stat.stat.exists

- name: Create bootstrap sentinel file
  ansible.builtin.file:
    path: "{{ playbook_dir }}/../vault-backup/{{ inventory_hostname }}/.approle_bootstrapped"
    state: touch
    mode: '0600'
  delegate_to: localhost
  become: false
  when: not approle_sentinel_stat.stat.exists

- name: Display AppRole bootstrap instructions
  ansible.builtin.debug:
    msg:
      - "AppRole bootstrapped!"
      - "role_id  : {{ vault_fetched_role_id }}"
      - "secret_id: {{ approle_secret_id_response.json.data.secret_id | default('(déjà généré — voir vault-backup/)') }}"
      - ""
      - "Ajouter dans inventory/host_vars/lightsail1/vault_secrets.yml (ansible-vault):"
      - "  vault_approle_role_id: \"{{ vault_fetched_role_id }}\""
      - "  vault_approle_secret_id: \"<secret_id depuis vault-backup/{{ inventory_hostname }}/approle_secret_id>\""
  run_once: true
```

- [ ] **Step 2: Vérifier la syntaxe YAML**

```bash
python3 -c "import yaml; yaml.safe_load(open('tarnished_lab/roles/vault/tasks/approle.yml'))" && echo "OK"
```

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add tarnished_lab/roles/vault/tasks/approle.yml
git commit -m "feat(vault): add AppRole bootstrap task"
```

---

### Task 3: Modifier tasks/main.yml

**Files:**
- Modify: `tarnished_lab/roles/vault/tasks/main.yml`

- [ ] **Step 1: Remplacer le contenu complet de main.yml**

```yaml
---
- name: Include remove tasks
  ansible.builtin.include_tasks: remove.yml
  tags: remove
  when: "'remove' in ansible_run_tags"

- name: Include install tasks
  ansible.builtin.include_tasks: install.yml
  tags: install
  when: "'remove' not in ansible_run_tags"

- name: Include initialization tasks
  ansible.builtin.include_tasks: init.yml
  tags: init
  when: "'remove' not in ansible_run_tags"

# Re-runs: vault_root_token n'est pas défini par init.yml (Vault déjà initialisé).
# On utilise AppRole pour obtenir un token éphémère (TTL 1h).
- name: AppRole login (re-runs only)
  ansible.builtin.uri:
    url: "{{ vault_local_api_url }}/v1/auth/approle/login"
    method: POST
    validate_certs: false
    body_format: json
    body:
      role_id: "{{ vault_approle_role_id }}"
      secret_id: "{{ vault_approle_secret_id }}"
    status_code: [200]
  register: approle_login_result
  when:
    - "'remove' not in ansible_run_tags"
    - vault_approle_role_id != ''
    - vault_approle_secret_id != ''
    - vault_root_token is not defined or vault_root_token == ''

- name: Set vault_root_token from AppRole login
  ansible.builtin.set_fact:
    vault_root_token: "{{ approle_login_result.json.auth.client_token }}"
  when:
    - approle_login_result is not skipped
    - approle_login_result.json.auth.client_token is defined

- name: Include AppRole setup tasks
  ansible.builtin.include_tasks: approle.yml
  tags: approle
  when:
    - vault_approle_enabled
    - "'remove' not in ansible_run_tags"

- name: Include KV setup tasks
  ansible.builtin.include_tasks: kv.yml
  tags: kv
  when:
    - vault_kv_enabled
    - "'remove' not in ansible_run_tags"

# PKI désactivé — activer vault_pki_enabled si nécessaire
# - name: Include PKI setup tasks
#   ansible.builtin.include_tasks: pki.yml
#   tags: pki
#   when:
#     - vault_pki_enabled
#     - "'remove' not in ansible_run_tags"
```

- [ ] **Step 2: Vérifier la syntaxe YAML**

```bash
python3 -c "import yaml; yaml.safe_load(open('tarnished_lab/roles/vault/tasks/main.yml'))" && echo "OK"
```

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add tarnished_lab/roles/vault/tasks/main.yml
git commit -m "feat(vault): add AppRole login and include in main tasks"
```

---

### Task 4: Bootstrap AppRole et ajouter les credentials dans vault_secrets.yml

**Files:**
- Modify (manuel): `tarnished_lab/inventory/host_vars/lightsail1/vault_secrets.yml`

- [ ] **Step 1: Lancer le playbook pour bootstrapper AppRole**

```bash
ansible-playbook -i tarnished_lab/inventory/hosts.yml \
  tarnished_lab/playbook/One4All.yml \
  --ask-vault-pass
```

Expected dans les logs : le debug affiche `role_id` et `secret_id`. Les fichiers suivants sont créés localement :
```
tarnished_lab/vault-backup/lightsail1/approle_role_id
tarnished_lab/vault-backup/lightsail1/approle_secret_id
tarnished_lab/vault-backup/lightsail1/.approle_bootstrapped
```

- [ ] **Step 2: Lire les credentials générés**

```bash
cat tarnished_lab/vault-backup/lightsail1/approle_role_id
cat tarnished_lab/vault-backup/lightsail1/approle_secret_id
```

- [ ] **Step 3: Ajouter les credentials dans vault_secrets.yml chiffré**

```bash
ansible-vault edit tarnished_lab/inventory/host_vars/lightsail1/vault_secrets.yml
```

Ajouter dans le fichier déchiffré :
```yaml
vault_approle_role_id: "<contenu de approle_role_id>"
vault_approle_secret_id: "<contenu de approle_secret_id>"
```

- [ ] **Step 4: Vérifier le re-run complet via AppRole**

```bash
ansible-playbook -i tarnished_lab/inventory/hosts.yml \
  tarnished_lab/playbook/One4All.yml \
  --ask-vault-pass
```

Expected dans les logs Ansible :
- `AppRole login (re-runs only)` → `changed`
- `Set vault_root_token from AppRole login` → `ok`
- `Upload ansible-admin policy` → `ok`
- `Enable AppRole auth method` → `skipped`
- `Create/update AppRole role` → `ok`
- `Generate secret_id (first bootstrap only)` → `skipped`
- Aucune erreur

- [ ] **Step 5: Vérifier sur Vault**

```bash
# Dans un terminal avec le tunnel SSH actif
export VAULT_ADDR=https://localhost:8200
export VAULT_SKIP_VERIFY=true
export VAULT_TOKEN=<root-token-depuis-vault-backup/lightsail1/root_token>

vault auth list             # "approle/" doit apparaître
vault policy read ansible-admin  # contenu de admin.hcl
vault read auth/approle/role/ansible  # config du rôle
```

- [ ] **Step 6: Commit**

```bash
git add tarnished_lab/inventory/host_vars/lightsail1/vault_secrets.yml
git commit -m "feat(vault): add AppRole credentials to vault_secrets (encrypted)"
```
