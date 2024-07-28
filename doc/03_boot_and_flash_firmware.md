
# Boot linux and flash OpenWrt firmware to the NAS

### Booting to Lubuntu from USB key
- Plug the USB key to the front USB port (USB 3.0).
- Press and hold the backup button on the bottom left of the front side of the NAS.
- Power on the NAS, keeping the backup button pressed for at least 10s then release it.
  The NAS should start booting on USB.
- Press enter to display login prompt, login with login "lubuntu" and no password.

You can log in as soon as the prompt appears, but lubuntu will carry on to load desktop services in the background and corresponding start logs will continue to be sent to the terminal, which can be a bit annoying. You can just wait until all services are loaded to avoid this. The last line should be something like
```
[  OK  ] Finished casper-md5check.service)
```
### Flashing OpenWrt firmware
#### Become root
```
sudo -i
```

#### Identify EMMC disk
```
EMMC=$( lsblk | grep -E "sd[a-z1-9]{1}\s.+" | egrep "119" | egrep "sd[a-z1-9]{1}" -o )
```

#### Write image
```
dd if=/cdrom/firmware/openwrt-23.05.4-0b9e37d1c62e-x86-64-generic-squashfs-combined.img bs=1M of=${EMMC}
```
#### Resize partition 2
```
parted /dev/${EMMC} resizepart 2 125
```

#### Finally :
- Reboot, wait for OpenWrt to finish boot.
- Go to http://IPADDR or start an SSH connection using the ip address you set up in [phase 1](01_prepare_usb_boot_key.md).
- Login using passord set up in [phase 1](01_prepare_usb_boot_key.md).

Tadaaaaaaa !

- [< Step 2 : Connect to serial port and BIOS setup](02_connect_to_serial_port.md)
- [> Step 4 : OpenWRT first boot and setup](04_openwrt_first_boot_and_setup.md)