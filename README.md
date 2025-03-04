# Reinstall

A simple script to reinstall your VPS with cloud image.

## Supported Target Systems

| System    | Version |
|-----------|---------|
| Debian    | 12      |
| Ubuntu    | 24      |
| Fedora    | 41      |
| Rocky     | 9       |

The current system must be **Debian 12/Ubuntu 22+**.

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
