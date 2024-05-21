apt-get update
apt-get install isc-dhcp-relay -y

echo '
SERVERS="10.73.3.3"
INTERFACES="eth1 eth2 eth3 eth4"
OPTIONS=""
' > /etc/default/isc-dhcp-relay

echo '
net.ipv4.ip_forward=1
' > /etc/sysctl.conf

service isc-dhcp-relay start

service isc-dhcp-relay status