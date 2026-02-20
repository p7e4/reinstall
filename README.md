# Reinstall

A simple script reinstall your VPS to major Linux system using cloud image.

## Target System

| System        | Version | Image                                             | Size |
|---------------|---------|---------------------------------------------------|------|
| Debian        | 13      | debian-13-genericcloud-amd64.qcow2                | 322M |
| Ubuntu        | 24.04   | noble-server-cloudimg-amd64.img                   | 599M |
| Fedora        | 43.1.6  | Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2     | 556M |
| Rocky         | 10      | Rocky-10-GenericCloud-Base.latest.x86_64.qcow2    | 548M |
| AlmaLinux     | 10      | AlmaLinux-10-GenericCloud-latest.x86_64.qcow2     | 479M |
| Archlinux     | rolling | Arch-Linux-x86_64-cloudimg.qcow2                  | 515M |

The host system must be **Debian 10/Ubuntu 18** or Rocky Linux 10/AlmaLinux 10 (target system not fedora/archlinux), older version might work but not been fully tested.

> The host server minimum memory should be larger than the image size, recommend at least 1GB.

## Quick Start

```
# Download the reinstall.sh
# or https://raw.githubusercontent.com/p7e4/reinstall/refs/heads/main/reinstall.sh
curl -O https://cdn.jsdelivr.net/gh/p7e4/reinstall/reinstall.sh

# reinstall system to debian and setup password
bash reinstall.sh -p <your_password> -s debian

# reinstall system to debian and setup ssh key
bash reinstall.sh -k <your_ssh-key> -s debian

```

after reboot, then ssh with root user


## Parameters

| Optional | Default      | Description               |
|----------|--------------|---------------------------|
| -k       | none         | ssh key authentication    |
| -p       | none         | password                  |
| -n       | vm-$(system) | hostname                  |
| -s       | none         | target system, one of debian/ubuntu/fedora/rocky/almalinux/archlinux |


## Related Repositories

- [bin456789/reinstall](https://github.com/bin456789/reinstall)
- [bohanyang/debi](https://github.com/bohanyang/debi)
