---
name: OpenClaw Role Cross-Platform Architecture
description: openclaw role supports macOS (launchd), Debian/Linux/RPi (systemd user), and RedHat — platform vars in vars/, dispatched via include_vars + include_tasks
type: project
---

The `tarnished_lab/roles/openclaw/` role was refactored to support three platforms.

**Architecture:**
- `vars/Darwin.yml`, `vars/Debian.yml`, `vars/RedHat.yml` hold all platform-specific paths. Loaded via `include_vars: "{{ ansible_os_family }}.yml"` at the top of `tasks/main.yml`.
- `tasks/install.yml` and `tasks/remove.yml` are dispatchers using `include_tasks` (dynamic) conditioned on `ansible_os_family`.
- macOS uses launchd (`~/Library/LaunchAgents`), Linux/RPi uses systemd user scope (`~/.config/systemd/user`).
- Raspberry Pi is covered automatically by `vars/Debian.yml` — no special branching needed (`ansible_os_family == 'Debian'`).

**Key facts:**
- `openclaw_bin` is a `set_fact` set during install (not in defaults) because path depends on npm install location.
- `handlers/main.yml` uses `listen: Reload OpenClaw service` with two platform-specific handlers (one macOS, one Linux).
- `apt` install and `loginctl enable-linger` use `become: true` at task level; play-level `become: false`.
- `defaults/main.yml` has empty-string secrets (no Vault lookups hardcoded) — secrets supplied via Vault encrypted vars or `--extra-vars` at runtime.
- `community.general.npm` used for idempotent global npm installs.
- `openclaw.json.j2` and `openclaw.plist.j2` templates are not modified.

**Why:** Needed to extend from macOS-only to also support home lab Raspberry Pi (Debian ARM) and generic Linux.

**How to apply:** When adding new tasks to this role, follow the platform-dispatch pattern (dispatcher in install.yml/remove.yml, platform-specific file for the logic).
