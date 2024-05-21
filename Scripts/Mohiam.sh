apt-get update
apt-get install isc-dhcp-server -y
service isc-dhcp-server start

echo '
INTERFACESv4="eth0"
' > /etc/default/isc-dhcp-server

echo '
# Switch 1 - Harkonen
subnet 10.73.1.0 netmask 255.255.255.0 {
	range 10.73.1.14 10.73.1.28;
	range 10.73.1.49 10.73.1.70;
	option routers 10.73.1.0;
	option broadcast-address 10.73.1.255;
	option domain-name-servers 10.73.3.2; # IP Irulan
	default-lease-time 300; # 5 menit
	max-lease-time 5220; # 87 menit
}

# Switch 2 - Atreides
subnet 10.73.2.0 netmask 255.255.255.0 {
	range 10.73.2.15 10.73.2.25;
	range 10.73.2.200 10.73.2.210;
	option routers 10.73.2.0;
	option broadcast-address 10.73.2.255;
	option domain-name-servers 10.73.3.2; # IP Irulan
	default-lease-time 1200; # 30 menit
	max-lease-time 5220; # 87 menit
}

# Switch 3
subnet 10.73.3.0 netmask 255.255.255.0 {}

# Switch 4
subnet 10.73.4.0 netmask 255.255.255.0 {}
' >  /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart