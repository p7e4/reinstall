#!/bin/bash
# https://github.com/p7e4/reinstall

set -e
hostname=$(hostname)

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
      echo "Usage: $(basename $0) [-p password] [-k ssh-key] [-n hostname] -s system"
      exit 0
      ;;
  esac
done

if [ -z "$PASSWORD" ] && [ -z "$SSHKEY" ]; then
  echo "Error: either -k or -p parameter need to be provided"
  exit 1
fi

if [ "$SYSTEM" != "debian" ] && [ "$SYSTEM" != "ubuntu" ] && [ "$SYSTEM" != "fedora" ] && [ "$SYSTEM" != "rocky" ]; then
  echo "Error: -s parameter must be one of debian, ubuntu, fedora, rocky"
  exit 1
fi

if [ -f /etc/default/kexec ]; then
  sed -i 's/LOAD_KEXEC=true/LOAD_KEXEC=false/' /etc/default/kexec
fi

apt update && apt install -y qemu-utils jq

country=$(curl -s "https://ipinfo.io/" | jq -r ".country")
echo "server country: $country"

if [ "$country" == "CN" ]; then
  if [ "$SYSTEM" == "debian" ]; then
    imgUrl="https://mirrors.ustc.edu.cn/debian-cdimage/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    aptMirror="
apt:
  primary:
    - arches: [default]
      uri: https://mirrors.ustc.edu.cn/debian/
  security:
    - arches: [default]
      uri: https://mirrors.ustc.edu.cn/debian-security/"
  elif [ "$SYSTEM" == "ubuntu" ]; then
    imgUrl="https://mirrors.ustc.edu.cn/ubuntu-cloud-images/noble/current/noble-server-cloudimg-amd64.img"
    aptMirror="
apt:
  primary:
    - arches: [default]
      uri: https://mirrors.ustc.edu.cn/ubuntu/"
  elif [ "$SYSTEM" == "fedora" ]; then
    imgUrl="https://mirrors.ustc.edu.cn/fedora/releases/41/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2"
  elif [ "$SYSTEM" == "rocky" ]; then
    imgUrl="https://mirrors.ustc.edu.cn/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
  fi
  alpineHost="mirrors.nyist.edu.cn"
  dns="223.5.5.5, 223.6.6.6"
else
  if [ "$SYSTEM" == "debian" ]; then
    imgUrl="https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
  elif [ "$SYSTEM" == "ubuntu" ]; then
    imgUrl="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  elif [ "$SYSTEM" == "fedora" ]; then
    imgUrl="https://download.fedoraproject.org/pub/fedora/linux/releases/41/Cloud/x86_64/images/Fedora-Cloud-Base-UEFI-UKI-41-1.4.x86_64.qcow2"
  elif [ "$SYSTEM" == "rocky" ]; then
    imgUrl="https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
  fi
  alpineHost="dl-cdn.alpinelinux.org"
  dns="1.1.1.1, 8.8.8.8"
fi

rm -rf /reinstall
mkdir /reinstall && cd /reinstall

curl -o vmlinuz https://$alpineHost/alpine/latest-stable/releases/x86_64/netboot/vmlinuz-virt
curl -o initrd https://$alpineHost/alpine/latest-stable/releases/x86_64/netboot/initramfs-virt
curl -OLA reinstall $imgUrl

filename=$(basename $imgUrl)
modprobe nbd
qemu-nbd -c /dev/nbd0 $filename
sleep 1
mount $(fdisk -l | grep -E "/dev/nbd0p.*Linux (root|filesystem)" | awk '{print $1}') /mnt

if [ "$SSHKEY" ]; then
  echo "using ssh key auth, key: $SSHKEY"
  sshAuth="
users:
  - name: root
    ssh_authorized_keys:
      - $SSHKEY"
fi

if [ "$PASSWORD" ]; then
  echo "using password auth, password: $PASSWORD"
  passAuth="
chpasswd:
  expire: false
  users:
  - name: root
    password: $PASSWORD
    type: text
runcmd:
  - rm /etc/ssh/sshd_config.d/*
  - sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config"
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
        name: "e*"
      dhcp4: true
      dhcp4-overrides:
        use-dns: no
      nameservers:
        addresses: [$dns]\
$aptMirror$sshAuth$passAuth
EOF

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
cp /mnt/reinstall/$filename ./
umount /mnt
qemu-img dd if=$filename of=$(echo $disk | sed -E 's/[0-9]+$//') bs=1M
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
update-grub && grub-reboot reinstall
echo "reboot to continue"
