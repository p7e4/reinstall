# Reinstall

A simple script to reinstall your VPS with cloud image.

## Target System

| System        | Version | Image                                             | Size |
|---------------|---------|---------------------------------------------------|------|
| Debian        | 13      | debian-13-genericcloud-amd64.qcow2                | 326M |
| Ubuntu        | 24.04   | noble-server-cloudimg-amd64.img                   | 598M |
| Fedora        | 43      | Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2     | 557M |
| Rocky         | 10      | Rocky-10-GenericCloud-Base.latest.x86_64.qcow2    | 549M |
| AlmaLinux     | 10      | AlmaLinux-10-GenericCloud-latest.x86_64.qcow2     | 563M |
| CentOS Stream | 10      | CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2 | 1.5G |
| Archlinux     | rolling | Arch-Linux-x86_64-cloudimg.qcow2                  | 557M |

The current system must be **Debian 10/Ubuntu 18 or higher**.

## Usage

1. **Download the `reinstall.sh` script:**

    ```sh
    curl -O https://cdn.jsdelivr.net/gh/p7e4/reinstall/reinstall.sh
    ```
    or
    ``` sh
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
