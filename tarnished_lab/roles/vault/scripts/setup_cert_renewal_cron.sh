#!/bin/bash
#
# Setup Cron Job for Automatic Certificate Renewal
# Runs weekly to check and renew certificates if needed
#

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYBOOK_DIR="$(dirname "$SCRIPT_DIR")"
INVENTORY="${PLAYBOOK_DIR}/inventory/hosts.yml"
PLAYBOOK="${PLAYBOOK_DIR}/playbook/cert_renewal.yml"
CRON_JOB="0 2 * * 0 cd ${PLAYBOOK_DIR} && ansible-playbook -i ${INVENTORY} ${PLAYBOOK} >> /var/log/vault-cert-renewal.log 2>&1"

echo -e "${GREEN}=== Certificate Renewal Cron Setup ===${NC}"
echo

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "cert_renewal.yml"; then
    echo -e "${YELLOW}Cron job already exists. Removing old entry...${NC}"
    crontab -l 2>/dev/null | grep -v "cert_renewal.yml" | crontab -
fi

# Add new cron job
echo -e "${GREEN}Adding cron job...${NC}"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

echo
echo -e "${GREEN}✓ Cron job added successfully!${NC}"
echo
echo -e "${YELLOW}Schedule:${NC} Every Sunday at 2:00 AM"
echo -e "${YELLOW}Log file:${NC} /var/log/vault-cert-renewal.log"
echo
echo -e "${YELLOW}To view cron jobs:${NC}"
echo "  crontab -l"
echo
echo -e "${YELLOW}To remove:${NC}"
echo "  crontab -e"
echo "  (then delete the cert_renewal.yml line)"
echo
echo -e "${YELLOW}To run manually:${NC}"
echo "  cd ${PLAYBOOK_DIR}"
echo "  ansible-playbook -i ${INVENTORY} ${PLAYBOOK}"
