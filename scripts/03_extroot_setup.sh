#!/bin/ash

# THIS WILL ENABLE EXTROOT OPENWRT FEATURE TO THE RAID1 ARRAY /dev/md0
# SOURCE : https://openwrt.org/docs/guide-user/additional-software/extroot_configuration

opkg update
opkg install block-mount kmod-fs-ext4 e2fsprogs parted kmod-usb-storage

DISK="/dev/md0"
MNT="/mnt/md0"
umount ${MNT}
rm -Rf /mnt/md0
sleep 1
#parted -s ${DISK} -- mklabel gpt mkpart extroot 2048s -2048s
mkfs.ext4 -L extroot ${DISK} <<EOF
y
EOF

# Configure the extroot mount entry.
eval $(block info ${DISK} | grep -o -e 'UUID="\S*"')
eval $(block info | grep -o -e 'MOUNT="\S*/overlay"')
uci -q delete fstab.extroot
uci set fstab.extroot="mount"
uci set fstab.extroot.uuid="${UUID}"
uci set fstab.extroot.target="${MOUNT}"
uci set fstab.extroot.enabled='1'
uci commit fstab
sleep 2

# Configure a mount entry for the the original overlay.
ORIG="$(block info | sed -n -e '/MOUNT="\S*\/overlay"/s/:\s.*$//p')"
uci -q delete fstab.rwm
uci set fstab.rwm="mount"
uci set fstab.rwm.device="${ORIG}"
uci set fstab.rwm.target="/rwm"
#uci set fstab.@global[0].delay_root="15"
uci commit fstab
sleep 2

# Transfer the content of the current overlay to the external drive.
mount ${DISK} /mnt
tar -C ${MOUNT} -cvf - . | tar -C /mnt -xf -

# SETUP FSTAB IN UCI TO AUTOMOUNT RAID PARTITION
#block detect | uci import fstab
#uci set fstab.@mount[-1].enabled='1'
#uci set fstab.@global[0].check_fs='1'
#uci commit fstab
#sleep 2

#reboot