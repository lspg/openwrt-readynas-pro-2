# OpenWrt first run and setup

## RAID (Optional)

The script 02_raid1_setup.sh will create a RAID1 array.
I intentionally did not include it in OpenWrt first run start script, but it can be done as long as you are sure you don't care about data on your disks, as they will totally be wiped during the creation process.

Make an SSH connection then do :

```
curl -o- https://github.com/lspg/openwrt-readynas-pro-2/blob/c0d0e524640eb99ac551fd2f3423fa4b3764cb43/scripts/02_raid1_setup.sh | ash
```

Then reboot and check if /mnd/md0 web ui mounted points.

## SAMBA file sharing (Optional)

If you configured RAID you'll surely want to share this storage over your network.

[To be continued...]

[< Step 3 : Boot and flash firmware](03_boot_and_flash_firmware.md)