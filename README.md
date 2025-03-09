# Reinstall

A simple script to reinstall your VPS with cloud image.

## Target Systems

| System        | Version | Image                                             | Size |
|---------------|---------|---------------------------------------------------|------|
| Debian        | 12      | debian-12-genericcloud-amd64.qcow2                | 331M |
| Ubuntu        | 24.04   | noble-server-cloudimg-amd64.img                   | 581M |
| Fedora        | 41      | Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2     | 468M |
| Rocky         | 9       | Rocky-9-GenericCloud-Base.latest.x86_64.qcow2     | 581M |
| AlmaLinux     | 9       | AlmaLinux-9-GenericCloud-latest.x86_64.qcow2      | 468M |
| CentOS Stream | 10      | CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2 | 904M |
| Archlinux     | rolling | Arch-Linux-x86_64-cloudimg.qcow2                  | 525M |

The current system must be **Debian 10/Ubuntu 18 or higher**.

## Usage

1. **Download the `reinstall.sh` script:**

    ```sh
    curl -O https://raw.githubusercontent.com/p7e4/reinstall/refs/heads/main/reinstall.sh
    ```

2. **Run the script:**

    Use SSH public key for authentication:

    ```sh
    bash reinstall.sh -k "ssh-rsa your_key" -s debian
    ```

    Or use password for authentication:

    ```sh
    bash reinstall.sh -p your_password -s debian
    ```

    Optionally, you can set up the hostname:

    ```sh
    bash reinstall.sh -p your_password -s debian -n your_hostname
    ```

## Related Repositories

- [bin456789/reinstall](https://github.com/bin456789/reinstall)
- [bohanyang/debi](https://github.com/bohanyang/debi)
