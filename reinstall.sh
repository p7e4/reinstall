#!/bin/bash
# https://github.com/p7e4/reinstall
# https://cdn.jsdelivr.net/gh/p7e4/reinstall/reinstall.sh

set -e
info() { echo -e "\e[32m[+] $1\e[0m"; }
error() { echo -e "\e[31m[!] $1\e[0m"; }
while getopts "p:k:s:n:" opt; do
  case $opt in
    p)
      PASSWORD=$OPTARG
      ;;
    k)
      SSHKEY=$OPTARG
      ;;
    s)
      SYSTEM=$OPTARG
      ;;
    n)
      hostname=$OPTARG
      ;;
    h | *)
      info "Usage: $(basename $0) [-p password] [-k ssh-key] [-n hostname] -s debian/ubuntu/fedora/rocky/almalinux/archlinux"
      exit 0
      ;;
  esac
done

if [ -z "$PASSWORD" ] && [ -z "$SSHKEY" ]; then
  error "either -k or -p parameter need to be provided"
  exit 1
fi

SYSTEM=$(echo "$SYSTEM" | tr '[:upper:]' '[:lower:]')
if [ "$SYSTEM" != "debian" ] && \
   [ "$SYSTEM" != "ubuntu" ] && \
   [ "$SYSTEM" != "fedora" ] && \
   [ "$SYSTEM" != "rocky" ] && \
   [ "$SYSTEM" != "almalinux" ] && \
   [ "$SYSTEM" != "archlinux" ]; then
  error "target system must be one of debian, ubuntu, fedora, rocky, almalinux, archlinux"
  exit 1
fi

if [ -z "$hostname" ]; then
  hostname="vm-$SYSTEM"
fi

info "set target system: $SYSTEM"

if [ -f /etc/default/kexec ]; then
  sed -i 's/LOAD_KEXEC=true/LOAD_KEXEC=false/' /etc/default/kexec
fi

info "install dependencies"
if command -v apt &> /dev/null; then
  apt update && apt install -y qemu-utils jq
elif command -v dnf &> /dev/null; then
  dnf makecache && dnf install -y qemu-img jq
else
  error "unsuport os type"
  exit 1
fi

# if [[ $SYSTEM == "archlinux" || $SYSTEM == "fedora" ]]; then
#   modprobe btrfs
# fi

country=$(curl -s "https://ipinfo.io/" | jq -r ".country")
info "server location code: $country"

if [ "$country" == "CN" ]; then
  if [ "$SYSTEM" == "debian" ]; then
    imgUrl="https://mirrors.nju.edu.cn/debian-cdimage/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
    aptMirror="
apt:
  primary:
    - arches: [default]
      uri: https://mirrors.ustc.edu.cn/debian/
  security:
    - arches: [default]
      uri: https://mirrors.ustc.edu.cn/debian-security/"
  elif [ "$SYSTEM" == "ubuntu" ]; then
    imgUrl="https://mirrors.nju.edu.cn/ubuntu-cloud-images/noble/current/noble-server-cloudimg-amd64.img"
    shaSum="https://cloud-images.ubuntu.com/noble/current/SHA256SUMS"
    aptMirror="
apt:
  sources_list: |
    Types: deb
    URIs: https://mirrors.ustc.edu.cn/ubuntu/
    Suites: noble noble-updates noble-security noble-backports
    Components: main universe restricted multiverse
    Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg"
  elif [ "$SYSTEM" == "fedora" ]; then
    imgUrl="https://mirrors.nju.edu.cn/fedora/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
  elif [ "$SYSTEM" == "rocky" ]; then
    imgUrl="https://mirrors.nju.edu.cn/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
    shaSum="https://mirrors.nju.edu.cn/rocky/10/images/x86_64/CHECKSUM"
  elif [ "$SYSTEM" == "almalinux" ]; then
    imgUrl="https://mirrors.nju.edu.cn/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-latest.x86_64.qcow2"
    shaSum="https://mirrors.nju.edu.cn/almalinux/10/cloud/x86_64/images/CHECKSUM"
  elif [ "$SYSTEM" == "archlinux" ]; then
    imgUrl="https://mirrors.nju.edu.cn/archlinux/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
    shaSum="https://mirrors.nju.edu.cn/archlinux/images/latest/Arch-Linux-x86_64-cloudimg.qcow2.SHA256"
  fi
  alpineHost="mirrors.nju.edu.cn"
  dns="223.5.5.5, 223.6.6.6"
else
  if [ "$SYSTEM" == "debian" ]; then
    imgUrl="https://cdimage.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
  elif [ "$SYSTEM" == "ubuntu" ]; then
    imgUrl="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    shaSum="https://cloud-images.ubuntu.com/noble/current/SHA256SUMS"
  elif [ "$SYSTEM" == "fedora" ]; then
    imgUrl="https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
  elif [ "$SYSTEM" == "rocky" ]; then
    imgUrl="https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
    shaSum="https://dl.rockylinux.org/pub/rocky/10/images/x86_64/CHECKSUM"
  elif [ "$SYSTEM" == "almalinux" ]; then
    imgUrl="https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-latest.x86_64.qcow2"
    shaSum="https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/CHECKSUM"
  elif [ "$SYSTEM" == "archlinux" ]; then
    imgUrl="https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
    shaSum="https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2.SHA256"
  fi
  alpineHost="dl-cdn.alpinelinux.org"
  dns="1.1.1.1, 8.8.8.8"
fi

rm -rf /reinstall
mkdir /reinstall && cd /reinstall

info "start download vmlinuz"
curl -o vmlinuz https://$alpineHost/alpine/latest-stable/releases/x86_64/netboot/vmlinuz-virt
info "start download initrd"
curl -o initrd https://$alpineHost/alpine/latest-stable/releases/x86_64/netboot/initramfs-virt
info "start download image form $imgUrl"
curl -OLA reinstall $imgUrl
imageFile=$(basename $imgUrl)

if [ "$shaSum" ]; then
  info "verify image hash"
  curl -A reinstall -o SHA256SUMS $shaSum
  sha256sum -c SHA256SUMS --ignore-missing 2>&1 | grep OK || (echo "$imageFile sha256 verify faile!" && exit 1)
fi

info "pack the cloud-init configuration file into image"
modprobe nbd
qemu-nbd -c /dev/nbd0 $imageFile
sleep 1
mount $(fdisk -l | grep -E "/dev/nbd0p.*Linux (root|filesystem)" | awk 'END {print $1}') /mnt

if [ "$SSHKEY" ]; then
  info "using ssh public key authentication"
  sshAuth="
users:
  - name: root
    ssh_authorized_keys:
      - $SSHKEY"
fi

if [ "$PASSWORD" ]; then
  info "using password authentication"
  passAuth="
ssh_pwauth: true
chpasswd:
  expire: false
  users:
    - name: root
      password: $PASSWORD
      type: text
runcmd:
  - sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
  - lsb_release -c | grep noble || systemctl restart sshd"
fi

if [ "$SYSTEM" == "fedora" ]; then
  cloudFilePath=/mnt/root/etc/cloud/cloud.cfg.d/custom.cfg
else
  cloudFilePath=/mnt/etc/cloud/cloud.cfg.d/custom.cfg
fi

cat > $cloudFilePath << EOF
#cloud-config
datasource_list: [None]
hostname: $hostname
timezone: Asia/Shanghai
network:
  version: 2
  ethernets:
    interface:
      match:
        name: e*
      dhcp4: true
      dhcp6: false
      dhcp4-overrides:
        use-dns: no
      nameservers:
        addresses: [$dns]\
$aptMirror$sshAuth$passAuth
EOF

# systemd-networkd match won't work at archlinux
if [ "$SYSTEM" == "archlinux" ]; then
  sed -i "5,16d" $cloudFilePath
fi

umount /mnt && qemu-nbd -d /dev/nbd0

mkdir tmp && cd tmp
gzip -d < ../initrd | cpio -id
sed -i '/^exec switch_root/i\mv post.start $sysroot/etc/local.d/\nln -s /etc/init.d/local $sysroot/etc/runlevels/default/' init

disk=$(df / | awk 'NR==2 {print $1}')
cat > post.start << EOF
mount / -o remount,size=100%
echo -e "\nhttps://${alpineHost}/alpine/latest-stable/community/" >> /etc/apk/repositories
apk add --no-cache util-linux qemu-img
mount $disk /mnt
cp /mnt/reinstall/$imageFile ./
umount /mnt
qemu-img dd if=$imageFile of=$(echo $disk | sed -E 's/[0-9]+$//') bs=1M
reboot
EOF
chmod +x post.start

find . | cpio -H newc -oF ../initrd
cd .. && rm -rf tmp

cat > /etc/grub.d/40_custom << EOF
#!/bin/sh
exec tail -n +3 \$0
set timeout=3
menuentry "reinstall" {
  search -n -f --set=root /reinstall/vmlinuz
  linux /reinstall/vmlinuz alpine_repo=https://$alpineHost/alpine/latest-stable/main/ modloop=https://$alpineHost/alpine/latest-stable/releases/x86_64/netboot/modloop-virt
  initrd /reinstall/initrd
}
EOF

info "update grub"
if command -v update-grub &> /dev/null; then
  update-grub && grub-reboot reinstall
elif command -v grub2-mkconfig  &> /dev/null; then
  grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-reboot reinstall
else
  error "unable to update grub configuration"
  exit 1
fi

info "reboot to continue"
