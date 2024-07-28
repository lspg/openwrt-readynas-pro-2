#!/bin/ash

# BOTH DISKS MUST HAVE SAME SIZE FOR RAID 1 (MIRRORING) ARRAY.
# !!!!! EVERYTHING WILL WE LOST ON BOTH DISKS !!!!!

opkg update
opkg install block-mount mdadm

# JUST FOR REINSTALL
umount /mnt/md0
mdadm --stop /dev/md0
mdadm --remove /dev/md0
sleep 2

# FINDS HDDs EXCEPT INTERNAL 119M EMMC USB
HDDS=$( lsblk | grep -E "sd[a-z1-9]{1}\s.+" | egrep -v "119" | egrep "sd[a-z1-9]{1}" -o )

# CREATES SINGLE PRIMARY PARTITION THAT TAKES WHOLE DISK ON EACH FOUND HDD
while read line; do
  echo ""
  echo 'type=83' | sfdisk /dev/${line}
done < <(echo "$HDDS")
sleep 2

# CREATES RAID1 ARRAY
HDDPARTS=$( lsblk | grep -E "sd[a-z1-9]{2}.+" | egrep -v "boot|rom" | egrep "sd[a-z1-9]{2}" -o )
HDDPARTS=$( echo $HDDPARTS | tr -d '\n' | sed 's/sd/\/dev\/&/g' )
mdadm --create /dev/md0 --level=1 --raid-devices=2 --force $HDDPARTS <<EOF
y
y
EOF
sleep 2

# SETUP MDADM IN UCI
RAIDUUID=$(mdadm -D /dev/md0|egrep "[0-9a-f]{8}:[0-9a-f]{8}:[0-9a-f]{8}:[0-9a-f]{8}" -o)
uci set mdadm.@array[0].uuid=${RAIDUUID}
uci commit mdadm
sleep 2

# SETUP FSTAB IN UCI TO AUTOMOUNT RAID PARTITION
block detect | uci import fstab
uci set fstab.@mount[-1].enabled='1'
uci set fstab.@global[0].check_fs='1'
uci commit fstab
sleep 2

service fstab boot