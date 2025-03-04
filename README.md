# Reinstall

A simple script to reinstall your VPS with cloud image.

## Supported Target Systems

| System    | Version | Size |
|-----------|---------|------|
| Debian    | 12      | 331M |
| Ubuntu    | 24.04   | 581M |
| Fedora    | 41      | 468M |
| Rocky     | 9       | 581M |
| Archlinux | latest  | 525M |

The current system must be **Debian 11/Ubuntu 20.04 or higher**.

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
