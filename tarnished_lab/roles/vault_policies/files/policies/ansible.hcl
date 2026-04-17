path "sys/auth/*" {
  capabilities = ["create", "read", "update", "delete", "sudo"]
}

path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/audit*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "auth/approle/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# One-shot bootstrap only — sentinel prevents re-execution on subsequent runs.
# sudo is required to assign policies outside the creator token's own policy set.
path "auth/token/create-orphan" {
  capabilities = ["create", "update", "sudo"]
}

path "secret/data/*" {
  capabilities = ["read"]
}

path "secret/metadata/*" {
  capabilities = ["read", "list"]
}
