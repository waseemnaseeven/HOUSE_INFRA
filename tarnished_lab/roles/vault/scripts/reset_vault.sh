#!/bin/bash
#
# Reset Vault - Complete Clean Slate
# WARNING: This DESTROYS all Vault data and secrets!
#

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

RASPBERRY_PI_IP="${1:-192.168.1.178}"
RASPBERRY_PI_USER="${2:-wnaseeve}"

echo -e "${RED}========================================${NC}"
echo -e "${RED}    VAULT RESET - DESTRUCTIVE ACTION${NC}"
echo -e "${RED}========================================${NC}"
echo
echo -e "${YELLOW}This will:${NC}"
echo "  1. Stop Vault service"
echo "  2. Delete all Vault data (/opt/vault/data)"
echo "  3. Delete all Vault keys (/etc/vault.d/keys)"
echo "  4. Allow fresh initialization"
echo
echo -e "${RED}ALL SECRETS, CERTIFICATES, AND PKI DATA WILL BE LOST!${NC}"
echo
read -p "Type 'YES' to confirm: " confirm

if [ "$confirm" != "YES" ]; then
    echo "Aborted."
    exit 1
fi

echo
echo -e "${YELLOW}Connecting to Raspberry Pi...${NC}"

ssh ${RASPBERRY_PI_USER}@${RASPBERRY_PI_IP} 'bash -s' <<'ENDSSH'
set -euo pipefail

echo "Stopping Vault service..."
sudo systemctl stop vault

echo "Removing Vault data directory..."
sudo rm -rf /opt/vault/data/*

echo "Removing Vault keys..."
sudo rm -f /etc/vault.d/keys/root_token
sudo rm -f /etc/vault.d/keys/unseal_keys.json

echo "Starting Vault service..."
sudo systemctl start vault

echo "Waiting for Vault to start..."
sleep 5

echo "Checking Vault status..."
curl -s http://localhost:8200/v1/sys/init | jq .

echo
echo "✓ Vault reset complete!"
echo "Vault is now uninitialized and ready for fresh deployment."
ENDSSH

echo
echo -e "${GREEN}✓ Vault has been reset on Raspberry Pi${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Re-run the playbook:"
echo "     cd tarnished_lab"
echo "     ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml"
echo
echo "  2. This will initialize Vault fresh and create new keys"
