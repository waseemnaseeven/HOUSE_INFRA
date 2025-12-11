# Prometheus useful commands

Ci-dessous les commandes utiles afin d'installer plusieurs prometheus en http, https (TLS ou mTLS), suppression...

## Prometheus Enable HTTP

ansible-playbook -i inventory/hosts.yml playbook/prometheus.yml

## Prometheus Enable TLS

ansible-playbook -i inventory/hosts.yml playbook/prometheus.yml -e "prometheus_tls_server_enabled=True"

## Prometheus Enable mTLS

ansible-playbook -i inventory/hosts.yml playbook/prometheus.yml -e "prometheus_tls_server_enabled=True" -e "prometheus_tls_client_enabled=True"

## Prometheus HA

ansible-playbook -i inventory/hosts.yml playbook/prometheus.yml -e "prometheus_sidecar_enabled=True"

## Prometheus Remove

ansible-playbook -i inventory/hosts.yml playbook/prometheus.yml -e "prometheus_enabled=False"
