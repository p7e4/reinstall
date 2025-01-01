# reinstall

Reinstall your VPS with cloud image

## Support system

- debian
- ubuntu

The current system needs to be **debian/ubuntu**

Only support the latest version of the system, if you want old version, please change the script manually.


## Usage

download `reinstall.sh`

`wget https://raw.githubusercontent.com/p7e4/reinstall/refs/heads/main/reinstall.sh`

use ssh public key for authentication

`bash reinstall.sh -k "ssh-rsa your_key" -s debian`

use password for authentication

`bash reinstall.sh -p your_password -s debian`

setup hostname

`bash reinstall.sh -p your_password -s debian -n your_hostname`


## Related repo

- [bin456789/reinstall](https://github.com/bin456789/reinstall)
- [bohanyang/debi](https://github.com/bohanyang/debi)


