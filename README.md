# Reinstall

Easily reinstall your VPS with a cloud image.

## Supported Target Systems

- Debian
- Ubuntu
- Fedora
- Rocky

**Note:** The current system must be **Debian/Ubuntu**.

Only the latest versions of the systems are supported. If you need an older version, please modify the script manually.

## Usage

1. **Download the `reinstall.sh` script:**

    ```sh
    wget https://raw.githubusercontent.com/p7e4/reinstall/refs/heads/main/reinstall.sh
    ```

2. **Use SSH public key for authentication:**

    ```sh
    bash reinstall.sh -k "ssh-rsa your_key" -s debian
    ```

3. **Use password for authentication:**

    ```sh
    bash reinstall.sh -p your_password -s debian
    ```

4. **Set up hostname:**

    ```sh
    bash reinstall.sh -p your_password -s debian -n your_hostname
    ```

## Related Repositories

- [bin456789/reinstall](https://github.com/bin456789/reinstall)
- [bohanyang/debi](https://github.com/bohanyang/debi)
