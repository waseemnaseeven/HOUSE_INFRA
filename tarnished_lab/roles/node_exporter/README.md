# Node Exporter Useful Things

Ci-dessous, les commandes utiles afin d'installer node_exporter en http, https (TLS ou mTLS), suppression pour resintallation.

## Node Exporter Enable HTTP

ansible-playbook -i inventory/hosts.yml playbook/node_exporter.yml 

## Node Exporter Enable TLS

ansible-playbook -i inventory/hosts.yml playbook/node_exporter.yml -e "node_exporter_tls_server_enabled=True" 

## Node Exporter Enable mTLS

ansible-playbook -i inventory/hosts.yml playbook/node_exporter.yml -e "node_exporter_tls_server_enabled=True" -e "node_exporter_tls_client_enabled=True" 

## Node Exporter Remove

ansible-playbook -i inventory/hosts.yml playbook/node_exporter.yml -e "node_exporter_enabled=False"


