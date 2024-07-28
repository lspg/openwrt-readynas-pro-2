#!/bin/ash

# CONFIG - EDIT THIS SECTION TO FIT YOUR NEEDS
IPADDR=192.168.1.1
GATEWAY=192.168.1.254
NETMASK=255.255.255.0
DNS='192.168.1.1 192.168.1.2'
ROOTPASSWORD=readynas

# NETWORK CONFIG
echo 'Configuring network'
uci set network.lan.ipaddr=${IPADDR}
uci set network.lan.gateway=${GATEWAY}
uci set network.lan.netmask=${NETMASK}
uci set network.lan.dns=''
for s in ${DNS} ; do
  uci add_list network.lan.dns=$s
done
uci set dhcp.lan.ignore="1"
uci commit network

/etc/init.d/network restart
uci commit dhcp
service dnsmasq restart
service odhcpd restart

opkg update

# === Update root password =====================
echo 'Updating root password'
passwd <<EOF
$ROOTPASSWORD
$ROOTPASSWORD
EOF