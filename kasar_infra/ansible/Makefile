ANSIBLE_PLAYBOOK = ansible-playbook
INVENTORY = -i inventory/hosts.yml
PLAYBOOK_DIR = playbook

# -------------- Docker -------------- #

docker:
	@echo "$(_ORANGE)Docker playbook execution$(_NO)"
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/docker.yml

# -------------- Vault -------------- #

vault_install:
	@echo "$(_ORANGE)Vault playbook installation$(_NO)"
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/vault.yml --tags install

vault_remove:
	@echo "$(_ORANGE)Vault playbook remove$(_NO)"
	$(ANSIBLE_PLAYBOOK) $(INVENTORY) $(PLAYBOOK_DIR)/vault.yml --tags remove

# -------------- Syntaxing -------------- #
_NO                    = \033[0m
_BOLD                  = \033[1m
_BLUE                  = \033[34m
_CYAN                  = \033[36m
_RED                   = \033[31m
_PURPLE                = \033[35m
_PINK_ORANGE           = \033[38;5;215m
_GREY                  = \033[38;5;234m
_STARLIGHT_BLUE        = \033[38;5;158m
_STARLIGHT_GREEN       = \033[38;5;157m
_DEEP_BLUE             = \033[38;5;69m
_YELLOW                = \033[38;5;226m
_ORANGE                = \033[38;5;209m\e[1m
# ------------------------------------- #

