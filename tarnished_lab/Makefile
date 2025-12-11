# ═══════════════════════
#  TARNISHED LAB 
# ═══════════════════════

ANSIBLE_PLAYBOOK := ansible-playbook
INVENTORY        := -i inventory/hosts.yml
PLAYBOOK_DIR     := playbook
SCRIPTS_DIR      := scripts
PI_HOST          := wnaseeve@192.168.1.178

.DEFAULT_GOAL := help
.PHONY: help deploy vpn vault vault-reset vault-backup vault-status vault-unseal \
        cert-renew cert-check cert-setup-cron client-add logs-vault logs-vpn ssh

# ═══════════════════════════════════════════════════════════════
#  HELP
# ═══════════════════════════════════════════════════════════════

help:
	@echo ""
	@echo "$(_BOLD)$(_ORANGE)╔═══════════════════════════════════════════════════════════════╗$(_NO)"
	@echo "$(_BOLD)$(_ORANGE)║          TARNISHED LAB - Infrastructure Commands              ║$(_NO)"
	@echo "$(_BOLD)$(_ORANGE)╚═══════════════════════════════════════════════════════════════╝$(_NO)"
	@echo ""
	@echo "$(_BOLD)$(_STARLIGHT_BLUE)┌─ Quick Start$(_NO)"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_GREY)│$(_NO) $(_CYAN)make deploy$(_NO)              Full deployment (Vault + OpenVPN)"
	@echo "$(_GREY)│$(_NO) $(_CYAN)make vault-backup$(_NO)        Create encrypted backup of keys"
	@echo "$(_GREY)│$(_NO) $(_CYAN)make vault-status$(_NO)        Check if Vault is healthy"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_BOLD)$(_STARLIGHT_BLUE)├─ Deployments$(_NO)"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_GREY)│$(_NO) $(_CYAN)make deploy$(_NO)              Deploy everything (Vault + OpenVPN + PKI)"
	@echo "$(_GREY)│$(_NO) $(_CYAN)make vault$(_NO)               Deploy Vault only (includes init + PKI)"
	@echo "$(_GREY)│$(_NO) $(_CYAN)make vpn$(_NO)                 Deploy OpenVPN only"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_BOLD)$(_STARLIGHT_BLUE)├─ Vault Operations$(_NO)"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_GREY)│$(_NO) $(_STARLIGHT_GREEN)make vault-status$(_NO)        Show Vault health (initialized/sealed/standby)"
	@echo "$(_GREY)│$(_NO) $(_STARLIGHT_GREEN)make vault-backup$(_NO)        Create GPG-encrypted backup (~/.vault-backups/)"
	@echo "$(_GREY)│$(_NO) $(_YELLOW)make vault-unseal$(_NO)        Unseal Vault if sealed"
	@echo "$(_GREY)│$(_NO) $(_RED)make vault-reset$(_NO)         ⚠️  DELETE everything & start fresh"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_BOLD)$(_STARLIGHT_BLUE)├─ Certificates$(_NO)"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_GREY)│$(_NO) $(_YELLOW)make cert-check$(_NO)          Check certificate expiration dates"
	@echo "$(_GREY)│$(_NO) $(_YELLOW)make cert-renew$(_NO)          Renew certificates (if < 30 days left)"
	@echo "$(_GREY)│$(_NO) $(_YELLOW)make cert-setup-cron$(_NO)     Setup weekly auto-renewal cron job"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_BOLD)$(_STARLIGHT_BLUE)├─ Client Management$(_NO)"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_GREY)│$(_NO) $(_CYAN)make client-add$(_NO)          Generate new OpenVPN client config"
	@echo "$(_GREY)│$(_NO)                           (Edit playbook/openvpn.yml first)"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_BOLD)$(_STARLIGHT_BLUE)├─ Monitoring & Logs$(_NO)"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_GREY)│$(_NO) $(_BLUE)make logs-vault$(_NO)          Follow Vault logs (live)"
	@echo "$(_GREY)│$(_NO) $(_BLUE)make logs-vpn$(_NO)            Follow OpenVPN logs (live)"
	@echo "$(_GREY)│$(_NO) $(_BLUE)make ssh$(_NO)                 SSH into Raspberry Pi"
	@echo "$(_GREY)│$(_NO)"
	@echo "$(_BOLD)$(_STARLIGHT_BLUE)└─────────────────────────────────────────────────────────────$(_NO)"
	@echo ""

# ═══════════════════════════════════════════════════════════════
#  DEPLOYMENTS
# ═══════════════════════════════════════════════════════════════

deploy: ## Full deployment: Vault + OpenVPN + PKI
	@echo ""
	@echo "$(_BOLD)$(_ORANGE)🚀 Starting full deployment...$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/openvpn.yml
	@echo ""
	@echo "$(_BOLD)$(_STARLIGHT_GREEN)✓ Deployment complete!$(_NO)"
	@echo "$(_GREY)  Next: make vault-backup && make cert-setup-cron$(_NO)"
	@echo ""

vault: ## Deploy Vault only (includes initialization + PKI)
	@echo ""
	@echo "$(_BOLD)$(_CYAN)🔐 Deploying Vault...$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/openvpn.yml --tags vault,init,pki
	@echo ""
	@echo "$(_BOLD)$(_STARLIGHT_GREEN)✓ Vault deployed!$(_NO)"
	@echo ""

vpn: ## Deploy OpenVPN only
	@echo ""
	@echo "$(_BOLD)$(_CYAN)🔒 Deploying OpenVPN...$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/openvpn.yml --tags openvpn
	@echo ""
	@echo "$(_BOLD)$(_STARLIGHT_GREEN)✓ OpenVPN deployed!$(_NO)"
	@echo ""

# ═══════════════════════════════════════════════════════════════
#  VAULT OPERATIONS
# ═══════════════════════════════════════════════════════════════

vault-status: ## Check Vault health status
	@echo ""
	@echo "$(_BOLD)$(_BLUE)📊 Vault Status$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	@ssh $(PI_HOST) 'curl -s http://localhost:8200/v1/sys/health' | jq '{ initialized, sealed, standby }'
	@echo ""

vault-backup: ## Create encrypted backup of Vault keys
	@echo ""
	@echo "$(_BOLD)$(_STARLIGHT_GREEN)💾 Creating encrypted backup...$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	@$(SCRIPTS_DIR)/backup_vault_keys.sh
	@echo ""

vault-unseal: ## Unseal Vault using saved keys
	@echo ""
	@echo "$(_BOLD)$(_YELLOW)🔓 Unsealing Vault...$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	@if [ ! -f vault-backup/raspberrypi/unseal_keys.json ]; then \
		echo "$(_RED)✗ Error: unseal_keys.json not found in vault-backup/raspberrypi/$(_NO)"; \
		exit 1; \
	fi
	@ssh $(PI_HOST) 'export VAULT_ADDR=http://localhost:8200 && \
		vault operator unseal $$(cat /etc/vault.d/keys/unseal_keys.json | jq -r .keys[0]) && \
		vault operator unseal $$(cat /etc/vault.d/keys/unseal_keys.json | jq -r .keys[1]) && \
		vault operator unseal $$(cat /etc/vault.d/keys/unseal_keys.json | jq -r .keys[2])'
	@echo ""
	@echo "$(_BOLD)$(_STARLIGHT_GREEN)✓ Vault unsealed!$(_NO)"
	@echo ""

vault-reset: ## ⚠️  DELETE all Vault data and start fresh
	@echo ""
	@echo "$(_BOLD)$(_RED)⚠️  Removing Vault...$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/vault_remove.yml -e vault_confirm_removal=DELETE
	@echo ""
	@echo "$(_BOLD)$(_STARLIGHT_GREEN)✓ Vault removed!$(_NO)"
	@echo "$(_GREY)  Next: make deploy$(_NO)"
	@echo ""

# ═══════════════════════════════════════════════════════════════
#  CERTIFICATE OPERATIONS
# ═══════════════════════════════════════════════════════════════

cert-check: ## Check certificate expiration dates
	@echo ""
	@echo "$(_BOLD)$(_YELLOW)📜 Certificate Expiration Check$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	@ssh $(PI_HOST) 'openssl x509 -in /etc/openvpn/server/server.crt -noout -dates'
	@echo ""

cert-renew: ## Renew certificates if < 30 days until expiration
	@echo ""
	@echo "$(_BOLD)$(_YELLOW)🔄 Certificate Renewal$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/cert_renewal.yml
	@echo ""

cert-setup-cron: ## Setup automatic weekly certificate renewal
	@echo ""
	@echo "$(_BOLD)$(_YELLOW)⏰ Setting up auto-renewal cron job...$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	@$(SCRIPTS_DIR)/setup_cert_renewal_cron.sh
	@echo ""

# ═══════════════════════════════════════════════════════════════
#  CLIENT MANAGEMENT
# ═══════════════════════════════════════════════════════════════

client-add: ## Generate new OpenVPN client configuration
	@echo ""
	@echo "$(_BOLD)$(_CYAN)👤 Generating OpenVPN Client Config$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	@echo "$(_YELLOW)⚠ Make sure you've added the client to playbook/openvpn.yml first!$(_NO)"
	@echo ""
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/openvpn.yml --tags clients
	@echo ""
	@echo "$(_BOLD)$(_STARLIGHT_GREEN)✓ Client configs generated in: /etc/openvpn/client/ on Pi$(_NO)"
	@echo "$(_GREY)  Download: scp $(PI_HOST):/etc/openvpn/client/<name>/<name>.ovpn .$(_NO)"
	@echo ""

# ═══════════════════════════════════════════════════════════════
#  MONITORING & LOGS
# ═══════════════════════════════════════════════════════════════

logs-vault: ## Follow Vault logs (live)
	@echo ""
	@echo "$(_BOLD)$(_BLUE)📋 Vault Logs (Ctrl+C to exit)$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	@ssh $(PI_HOST) 'sudo journalctl -u vault -f'

logs-vpn: ## Follow OpenVPN logs (live)
	@echo ""
	@echo "$(_BOLD)$(_BLUE)📋 OpenVPN Logs (Ctrl+C to exit)$(_NO)"
	@echo "$(_GREY)────────────────────────────────────────────────────────────$(_NO)"
	@ssh $(PI_HOST) 'sudo tail -f /var/log/openvpn/openvpn.log'

ssh: ## SSH into Raspberry Pi
	@echo ""
	@echo "$(_BOLD)$(_BLUE)🔌 Connecting to Raspberry Pi...$(_NO)"
	@echo ""
	@ssh $(PI_HOST)

# ═══════════════════════════════════════════════════════════════
#  COLORS & FORMATTING
# ═══════════════════════════════════════════════════════════════

_NO              = \033[0m
_BOLD            = \033[1m
_BLUE            = \033[34m
_CYAN            = \033[36m
_RED             = \033[31m
_YELLOW          = \033[33m
_GREY            = \033[90m
_ORANGE          = \033[38;5;208m
_STARLIGHT_BLUE  = \033[38;5;117m
_STARLIGHT_GREEN = \033[38;5;121m
