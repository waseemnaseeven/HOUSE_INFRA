# OpenVPN with HashiCorp Vault PKI Setup

This guide explains how to deploy a secure OpenVPN server on Raspberry Pi using HashiCorp Vault for certificate management.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Raspberry Pi                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐         ┌─────────────────────┐      │
│  │   Vault      │◄────────┤   OpenVPN Server    │      │
│  │  (PKI + KV)  │  certs  │  Port: 1194/UDP     │      │
│  └──────┬───────┘         └─────────────────────┘      │
│         │                                               │
│         │ Issues certificates                           │
│         └──► Server Certificate                         │
│         └──► Client Certificates                        │
└─────────────────────────────────────────────────────────┘
```

## Components

### 1. **HashiCorp Vault** ([roles/vault](roles/vault/))
- **Purpose**: Centralized PKI (Public Key Infrastructure) and secrets management
- **Features**:
  - Root CA and Intermediate CA
  - PKI secrets engine for certificate issuance
  - KV v2 secrets engine for storing configurations
  - Automatic initialization and unsealing
  - ARM64 architecture support for Raspberry Pi

### 2. **OpenVPN Server** ([roles/openvpn](roles/openvpn/))
- **Purpose**: Secure VPN server with Vault-issued certificates
- **Features**:
  - Automatic certificate generation from Vault
  - Client configuration file generation
  - NAT and firewall configuration
  - Compression and optimized crypto settings

### 3. **Vault Certificate Management** ([roles/vault_cert](roles/vault_cert/))
- **Purpose**: Flexible certificate issuance from Vault PKI
- **Features**:
  - Generate certificates on any host
  - Automatic renewal 4 weeks before expiration
  - Multiple certificate formats support

## Prerequisites

- Raspberry Pi (or any Debian/Ubuntu system)
- Ansible 2.9+
- SSH access to the target host
- Python packages:
  - `community.crypto` Ansible collection

Install required collections:
```bash
ansible-galaxy collection install community.crypto ansible.posix
```

## Quick Start

### 1. Update Inventory

Edit [`inventory/hosts.yml`](inventory/hosts.yml) and ensure your Raspberry Pi is configured:

```yaml
raspberry_pi:
  hosts:
    raspberrypi:
      ansible_host: 192.168.1.178  # Update with your Pi's IP
      ansible_user: wnaseeve         # Update with your username
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

### 2. Configure Variables (Optional)

The default configuration is production-ready, but you can customize:

**Vault Configuration** ([roles/vault/defaults/main.yml](roles/vault/defaults/main.yml)):
```yaml
vault_pki_ca_common_name: "Tarnished Lab Root CA"
vault_pki_int_common_name: "Tarnished Lab Intermediate CA"
```

**OpenVPN Configuration** ([roles/openvpn/defaults/main.yml](roles/openvpn/defaults/main.yml)):
```yaml
openvpn_port: 1194
openvpn_protocol: "udp"
openvpn_server_network: "10.8.0.0"
openvpn_push_dns:
  - "8.8.8.8"
  - "8.8.4.4"
```

### 3. Run the Playbook

Deploy everything with one command:

```bash
cd tarnished_lab
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml
```

This will:
1. Install and configure HashiCorp Vault
2. Initialize Vault with automatic unsealing
3. Set up PKI infrastructure (Root CA + Intermediate CA)
4. Enable KV secrets engine
5. Install and configure OpenVPN
6. Generate server certificates from Vault
7. Generate client configurations

**Estimated time**: 10-15 minutes (DH parameter generation takes ~5 minutes)

### 4. Retrieve Client Configuration

After successful deployment, client configurations are located at:
```bash
/etc/openvpn/client/<client-name>/<client-name>.ovpn
```

Download the `.ovpn` file to your client device:
```bash
scp wnaseeve@192.168.1.178:/etc/openvpn/client/client1/client1.ovpn .
```

### 5. Connect Your Client

**Linux/macOS**:
```bash
sudo openvpn --config client1.ovpn
```

**Windows**: Import `client1.ovpn` into OpenVPN GUI

**Mobile**: Use OpenVPN Connect app and import the `.ovpn` file

## Adding More Clients

Edit [`playbook/openvpn.yml`](playbook/openvpn.yml) and add clients to the list:

```yaml
openvpn_clients:
  - name: "client1"
    common_name: "client1.vpn.tarnished.lab"
  - name: "client2"
    common_name: "client2.vpn.tarnished.lab"
  - name: "phone"
    common_name: "phone.vpn.tarnished.lab"
```

Then re-run the playbook:
```bash
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml --tags clients
```

## Important Files and Locations

### On Raspberry Pi

| Path | Description |
|------|-------------|
| `/etc/vault.d/config.hcl` | Vault configuration |
| `/etc/vault.d/keys/root_token` | Vault root token (KEEP SECRET!) |
| `/etc/vault.d/keys/unseal_keys.json` | Vault unseal keys (BACKUP SECURELY!) |
| `/etc/vault.d/tls/ca.crt` | Root CA certificate |
| `/etc/openvpn/server/server.conf` | OpenVPN server configuration |
| `/etc/openvpn/server/server.crt` | Server certificate |
| `/etc/openvpn/server/server.key` | Server private key (KEEP SECRET!) |
| `/etc/openvpn/client/<name>/` | Client configuration directory |
| `/var/log/openvpn/openvpn.log` | OpenVPN logs |

### Vault Web UI

Access Vault UI at: `http://<raspberry-pi-ip>:8200`

Login with the root token from `/etc/vault.d/keys/root_token`

## Security Best Practices

### 1. **Backup Vault Keys**

**CRITICAL**: Backup these files immediately after deployment:
```bash
scp -r wnaseeve@192.168.1.178:/etc/vault.d/keys ~/vault-backup-$(date +%Y%m%d)/
```

Store in a secure location (encrypted USB drive, password manager, etc.)

### 2. **Firewall Configuration**

The playbook automatically configures iptables. Verify with:
```bash
sudo iptables -L -n -v
sudo iptables -t nat -L -n -v
```

### 3. **Monitor Vault Status**

```bash
# On Raspberry Pi
vault status

# Check if unsealed
vault operator unseal -status
```

### 4. **Rotate Certificates**

Certificates are valid for 1 year. Re-run the playbook before expiration:
```bash
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml --tags certs
```

## Troubleshooting

### Vault is Sealed

If Vault becomes sealed (e.g., after reboot), unseal it:

```bash
# Read unseal keys
cat /etc/vault.d/keys/unseal_keys.json

# Unseal (need 3 keys)
vault operator unseal <key-1>
vault operator unseal <key-2>
vault operator unseal <key-3>
```

Or re-run the init tasks:
```bash
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml --tags init
```

### OpenVPN Not Starting

Check logs:
```bash
sudo systemctl status openvpn@server
sudo journalctl -u openvpn@server -f
tail -f /var/log/openvpn/openvpn.log
```

Common issues:
- **Port already in use**: Change `openvpn_port` in defaults
- **Certificate issues**: Re-run certificate generation with `--tags certs`
- **Missing keys**: Check `/etc/openvpn/server/` for all required files

### Client Cannot Connect

1. **Check server status**:
   ```bash
   sudo systemctl status openvpn@server
   ```

2. **Verify firewall**:
   ```bash
   sudo ufw status  # If using UFW
   sudo iptables -L -n | grep 1194
   ```

3. **Test connectivity**:
   ```bash
   # From client
   ping <raspberry-pi-ip>
   nc -u <raspberry-pi-ip> 1194
   ```

4. **Check client logs**: Enable verbose logging in `.ovpn`:
   ```
   verb 4
   ```

### Certificate Expiration

Check certificate validity:
```bash
openssl x509 -in /etc/openvpn/server/server.crt -noout -dates
```

Renew certificates:
```bash
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml --tags certs
sudo systemctl restart openvpn@server
```

## Advanced Configuration

### Enable TLS for Vault

Edit [`roles/vault/defaults/main.yml`](roles/vault/defaults/main.yml):
```yaml
vault_tls_disable: false
```

Then place certificates in `/etc/vault.d/tls/`:
- `vault.crt` - Vault server certificate
- `vault.key` - Vault server private key

### Change OpenVPN Network

Edit [`roles/openvpn/defaults/main.yml`](roles/openvpn/defaults/main.yml):
```yaml
openvpn_server_network: "10.9.0.0"  # Change subnet
```

### Push Custom Routes

Add internal networks to client routing:
```yaml
openvpn_push_routes:
  - "192.168.1.0 255.255.255.0"   # Home network
  - "192.168.2.0 255.255.255.0"   # Additional network
```

### Use TCP Instead of UDP

```yaml
openvpn_protocol: "tcp"
```

TCP is more reliable but slower than UDP.

## Maintenance

### Re-run Playbook Safely

The entire playbook is idempotent - safe to run multiple times:
```bash
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml
```

### Run Specific Parts

```bash
# Only Vault setup
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml --tags vault

# Only OpenVPN
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml --tags openvpn

# Only certificates
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml --tags certs

# Only clients
ansible-playbook -i inventory/hosts.yml playbook/openvpn.yml --tags clients
```

### Check Service Status

```bash
# Vault
sudo systemctl status vault
vault status

# OpenVPN
sudo systemctl status openvpn@server
```

### View Active VPN Connections

```bash
cat /var/log/openvpn/openvpn-status.log
```

## Architecture Decisions

`★ Why HashiCorp Vault?`
- **Centralized PKI**: One source of truth for all certificates
- **Automatic Renewal**: Certificates can be easily renewed via API
- **Scalability**: Easy to issue certificates for hundreds of clients
- **Audit Trail**: All certificate issuance is logged
- **Future-Proof**: Can be extended to manage other secrets (database passwords, API keys, etc.)

`★ Why OpenVPN?`
- **Battle-Tested**: Industry standard for VPN
- **Cross-Platform**: Works on all major operating systems
- **Secure**: Strong encryption with AES-256-GCM
- **Flexible**: Easy to configure and customize

`★ Design Principles`
1. **Simplicity**: One command deploys everything
2. **Security**: Strong encryption, proper key management
3. **Idempotency**: Safe to re-run without breaking
4. **Production-Ready**: Proper logging, monitoring, and error handling

## License

This automation is provided as-is for educational and personal use.

## Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review logs on the Raspberry Pi
3. Verify your configuration in `defaults/main.yml` files

---

**Happy VPN-ing! 🔐🚀**
