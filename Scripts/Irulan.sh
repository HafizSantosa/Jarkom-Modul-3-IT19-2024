apt-get update
apt-get install bind9 -y

echo 'zone "harkonen.it19.com" {
	type master;
	file "/etc/bind/jarkom/harkonen.it19.com";
	};
    
    zone "atreides.it19.com" {
	type master;
	file "/etc/bind/jarkom/atreides.it19.com";
	};' > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom
cp /etc/bind/db.local /etc/bind/jarkom/harkonen.it19.com
cp /etc/bind/db.local /etc/bind/jarkom/atreides.it19.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     harkonen.it19.com. root.harkonen.it19.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      harkonen.it19.com.
@       IN      A       10.73.1.3
@       IN      AAAA    ::1
' > /etc/bind/jarkom/harkonen.it19.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     atreides.it19.com. root.atreides.it19.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      atreides.it19.com.
@       IN      A       10.73.2.3
@       IN      AAAA    ::1
' > /etc/bind/jarkom/atreides.it19.com

echo '
options {
	directory "/var/cache/bind";

	forwarders {
		192.168.122.1;
	};

	allow-query{any;};
	auth-nxdomain no;
	listen-on-v6 { any; };
};
' >/etc/bind/named.conf.options

service bind9 restart

