# Quick Reference

## Commands

```bash
make help           # Show all available commands
make deploy         # Full deployment (Vault + OpenVPN)
make vault-reset    # Delete all Vault data & start fresh
make vault-backup   # Create encrypted backup
make vault-status   # Check Vault health
```

## Initial Setup

```bash
# 1. Install prerequisites
ansible-galaxy collection install community.crypto ansible.posix

# 2. Update inventory
vim inventory/hosts.yml  # Set ansible_host to your Pi IP

# 3. Deploy
make deploy

# 4. Backup & setup auto-renewal
make vault-backup
make cert-setup-cron
```

## File Locations

**Local**: `tarnished_lab/vault-backup/` - Auto-fetched keys
**Pi**: `/etc/vault.d/keys/` - Root token & unseal keys

## Troubleshooting

```bash
# Vault sealed
ssh wnaseeve@192.168.1.178
curl http://localhost:8200/v1/sys/seal-status

# Check logs
sudo journalctl -u vault -f
sudo tail -f /var/log/openvpn/openvpn.log
```
