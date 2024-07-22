#
# Build an SD Card that will boot Alpine armv7 (32-bit) on a Raspberry PI (Model 2 minimum)
#

#
# tested on an Ubuntu 22.04 LTS VM running on Virtual box / Windowss 11 
#

#
# Warning this destroy evrything on the target device
#

mydev=/dev/sdb               # /dev/mmcblk0 sur mon PC Asus (lecteur de carte SD/MMC
part1=${mydev}1              # ${mydev}p1 si device de type mmcblk
part2=${mydev}2              # ${mydev}p1 si device de type mmcblk
part3=${mydev}3              # ${mydev}p3 si device de type mmcblk
mydevname=$(basename $part1) # mount point for the boot partition

KITS=~chris/distros/alpine
ALPINE_TARBALL=${KITS}/tarballs/alpine-rpi-3.18.0-armhf.tar.gz
HEADLESS_OVERLAY=${KITS}/overlays/headless.apkovl.tar.gz

#
# Verify presence of device
#
if ! lsblk ${mydev} >/dev/null 2>&1
then
  echo no such device ${mydev}
  exit
fi

set -x
sudo parted -s $mydev mklabel msdos                 # efface le disque (confirmation requise)
sudo parted -s $mydev mkpart primary fat32 0% 2GB   # partition de boot 2GB
sudo parted -s $mydev set  1 boot on                # rendre la première partition bootable
sudo parted -s $mydev mkpart primary ext4 2GB 55%   #
sudo parted -s $mydev mkpart primary ext4 55% 100%  #

# Formatter la boot partition
sudo mkdosfs -F32 ${part1}

# Formatter les deux autres partitions avec ext4
yes | sudo mkfs.ext4 ${part2}
yes | sudo mkfs.ext4 ${part3}

# Copier le boot block syslinux
sudo dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/mbr/mbr.bin of=$mydev
sudo syslinux ${part1}

sudo mkdir -p /media/$mydevname
sudo mount -t vfat ${part1} /media/$mydevname
sudo tar -p -s --atime-preserve --same-owner --one-top-level=/media/$mydevname -zxvf ${ALPINE_TARBALL}

# enable cgroup
echo "modules=loop,squashfs,sd-mod,usb-storage quiet console=tty1 cgroup_memory=1 cgroup_enable=memory" | sudo tee /media/$mydevname/cmdline.txt

sudo cp ${HEADLESS_OVERLAY}  /media/$mydevname

#
# La Configuration du wi-fi marche au premier boot mais pas aux suivants donc on ne fait pas
#

cat <<EOF | sudo tee /media/$mydevname/wpa_supplicant.conf
network={
	ssid="symphorines"
	psk="${MYWIFI_KEY}"
}
EOF

#
# Configuration de la mémoire GPU, gpu_meme=xx ne marche pas dans un fichier include apparemment
#
# On peut vérifier avec vcgencmd get_mem gpu
#
cat <<EOF | sudo tee /media/$mydevname/config.txt
[pi0]
kernel=boot/vmlinuz-rpi
initramfs boot/initramfs-rpi
[pi0w]
kernel=boot/vmlinuz-rpi
initramfs boot/initramfs-rpi
[pi1]
kernel=boot/vmlinuz-rpi
initramfs boot/initramfs-rpi
[pi02]
kernel=boot/vmlinuz-rpi2
initramfs boot/initramfs-rpi2
[pi2]
kernel=boot/vmlinuz-rpi2
initramfs boot/initramfs-rpi2
[pi3]
kernel=boot/vmlinuz-rpi2
initramfs boot/initramfs-rpi2
[pi3+]
kernel=boot/vmlinuz-rpi2
initramfs boot/initramfs-rpi2
[all]
gpu_mem=32
include usercfg.txt
EOF

# Copy unattend.sh
sudo cp unattended.sh /media/${mydevname}
sudo chmod a+x /media/${mydevname}/unattended.sh
