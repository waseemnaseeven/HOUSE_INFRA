

path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "list"]
}

path "sys/audit" {
  capabilities = ["read"]
}

path "sys/audit/*" {
  capabilities = ["create", "read", "update"]
}

# KV v2 application secrets — explicit paths, no wildcard.
path "secret/data/openclaw" {
  capabilities = ["read"]
}

path "secret/data/my_blog" {
  capabilities = ["read"]
}

path "secret/metadata/openclaw" {
  capabilities = ["read"]
}

path "secret/metadata/my_blog" {
  capabilities = ["read"]
}

# Token self-management — allows the AppRole token to renew itself during long runs.
path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}
