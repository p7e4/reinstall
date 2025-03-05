# Reinstall

A simple script to reinstall your VPS with cloud image.

## Target Systems

| System        | Version | Image                                             | Size |
|---------------|---------|---------------------------------------------------|------|
| Debian        | 12      | debian-12-genericcloud-amd64.qcow2                | 331M |
| Fedora        | 41      | Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2     | 468M |
| Rocky         | 9       | Rocky-9-GenericCloud-Base.latest.x86_64.qcow2     | 581M |
| Ubuntu        | 24.04   | noble-server-cloudimg-amd64.img                   | 581M |

The current system must be **Debian 10/Ubuntu 20.04 or higher**.

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
