# Reinstall

A simple script to reinstall your VPS to major Linux system using cloud image.

## Features

- **Short & Simple**: under 300 lines of Bash, easy to read and audit
- **Transparent & Clean**: use official cloud image, all tweaks via `cloud-init`, no hidden changes

## System Support

| System    | Version | Image                                          | Size |
|-----------|---------|------------------------------------------------|------|
| Debian    | 13      | debian-13-genericcloud-amd64.qcow2             | 323M |
| Ubuntu    | 26.04   | resolute-server-cloudimg-amd64v3.img           | 818M |
| Fedora    | 44      | Fedora-Cloud-Base-Generic-44-1.7.x86_64.qcow2  | 556M |
| Rocky     | 10      | Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 | 548M |
| AlmaLinux | 10      | AlmaLinux-10-GenericCloud-latest.x86_64.qcow2  | 488M |
| Archlinux | rolling | Arch-Linux-x86_64-cloudimg.qcow2               | 525M |

The host system require **Debian 10/Ubuntu 18/Fedora 42/Rocky Linux 9(target system not fedora/archlinux)/AlmaLinux 9/archlinux and above**, older version might work but not been fully tested.

> The minimum memory requirement for the host server should exceed the size of the image, better double.

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
after reboot, ssh to your server with root user

## Parameters

| Optional | Default      | Description               |
|----------|--------------|---------------------------|
| -k       | none         | ssh key authentication    |
| -p       | none         | password                  |
| -n       | vm-$(system) | hostname                  |
| -s       | none         | target system, one of debian/ubuntu/fedora/rocky/almalinux/arch |

## Related Repositories

- [bin456789/reinstall](https://github.com/bin456789/reinstall)
- [bohanyang/debi](https://github.com/bohanyang/debi)
