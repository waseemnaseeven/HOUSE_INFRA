#!/bin/bash
#
# Vault Keys Encrypted Backup Script
# Encrypts Vault keys and stores them securely
#

set -euo pipefail

# Configuration
BACKUP_SOURCE="${1:-../vault-backup}"
BACKUP_DEST="${2:-$HOME/.vault-backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="vault-keys-${TIMESTAMP}.tar.gz.gpg"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Vault Keys Encrypted Backup ===${NC}"
echo

# Check if source exists
if [ ! -d "$BACKUP_SOURCE" ]; then
    echo -e "${RED}Error: Backup source directory not found: $BACKUP_SOURCE${NC}"
    echo "Run the Ansible playbook first to fetch keys."
    exit 1
fi

# Check if GPG is installed
if ! command -v gpg &> /dev/null; then
    echo -e "${RED}Error: GPG is not installed${NC}"
    echo "Install with: brew install gnupg (macOS) or apt install gnupg (Linux)"
    exit 1
fi

# Create backup destination
mkdir -p "$BACKUP_DEST"

echo -e "${YELLOW}Creating encrypted backup...${NC}"
echo "Source: $BACKUP_SOURCE"
echo "Destination: $BACKUP_DEST/$BACKUP_NAME"
echo

# Create tar archive and encrypt with GPG
tar czf - -C "$BACKUP_SOURCE" . | \
    gpg --symmetric \
        --cipher-algo AES256 \
        --armor \
        --output "$BACKUP_DEST/$BACKUP_NAME"

if [ $? -eq 0 ]; then
    echo
    echo -e "${GREEN}✓ Backup created successfully!${NC}"
    echo -e "${GREEN}  $BACKUP_DEST/$BACKUP_NAME${NC}"
    echo
    echo -e "${YELLOW}Backup details:${NC}"
    ls -lh "$BACKUP_DEST/$BACKUP_NAME"
    echo
    echo -e "${YELLOW}To restore:${NC}"
    echo "  gpg --decrypt $BACKUP_DEST/$BACKUP_NAME | tar xzf -"
    echo
    echo -e "${RED}⚠ IMPORTANT:${NC}"
    echo "  1. Remember your GPG passphrase - it CANNOT be recovered"
    echo "  2. Store this backup in a secure location (encrypted USB, cloud, etc.)"
    echo "  3. Keep multiple copies in different locations"
else
    echo -e "${RED}✗ Backup failed!${NC}"
    exit 1
fi
