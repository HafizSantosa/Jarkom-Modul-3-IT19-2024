# Laporan Resmi Praktikum Jaringan Komputer Modul 3 Kelompok IT19

| NRP | Nama Anggota |
|-----|--------------|
| 5027221061 | Hafiz Akmaldi Santosa |
| 5027221049 | Arsyad Rizantha Maulana Salim |

## Topologi
![](/image/Topologi.png "test")

#### 0. Meregister domain name `atreides.yyy.com` untuk worker Laravel mengarah pada `Leto Atreides` dan mendaftarkan domain name `harkonen.yyy.com` untuk worker PHP mengarah pada `Vladimir Harkonen`.

Pertama buat bash untuk memasukkan config untuk meregister domain yang diminta:
```
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
```
Kemudian restart service bind9 dengan command:
```
service bind9 restart
```

#### 1. Melakukan konfigurasi sesuai dengan peta yang sudah diberikan.

<b>Arakis<b>
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.73.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.73.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.73.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 10.73.4.1
	netmask 255.255.255.0
```

<b>Dmitri dan Paul (Client)<b>
```
auto eth0
iface eth0 inet dhcp
```

<b>Vladimir (PHP Worker)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.1.3
	netmask 255.255.255.0
	gateway 10.73.1.1
```

<b>Rabban (PHP Worker)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.1.4
	netmask 255.255.255.0
	gateway 10.73.1.1
```

<b>Feyd (PHP Worker)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.1.5
	netmask 255.255.255.0
	gateway 10.73.1.1
```

<b>Leto (Laravel Worker)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.2.3
	netmask 255.255.255.0
	gateway 10.73.2.1
```

<b>Duncan (Laravel Worker)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.2.4
	netmask 255.255.255.0
	gateway 10.73.2.1
```

<b>Jessica (Laravel Worker)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.2.5
	netmask 255.255.255.0
	gateway 10.73.2.1
```

<b>Irulan (DNS Server)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.3.2
	netmask 255.255.255.0
	gateway 10.73.3.1
```

<b>Mohiam (DHCP Server)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.3.3
	netmask 255.255.255.0
	gateway 10.73.3.1
```

<b>Stilgar (Load Balancer)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.4.2
	netmask 255.255.255.0
	gateway 10.73.4.1
```

<b>Chani (Database Server)<b>
```
auto eth0
iface eth0 inet static
	address 10.73.4.3
	netmask 255.255.255.0
	gateway 10.73.4.1
```

#### 2. Client yang melalui House Harkonen mendapatkan range IP dari [prefix IP].1.14 - [prefix IP].1.28 dan [prefix IP].1.49 - [prefix IP].1.70

prefix IP IT19 = 10.73

Untuk memberikan akses internet kepada Harkonen(switch 1), lakukan configurasi berikut pada mohiam(DHCP Server).

```
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
}' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart
```
Kemudian periksa apakah client di Harkonen sudah dapat akses internet dengan `ping`.

#### 3. Client yang melalui House Atreides mendapatkan range IP dari [prefix IP].2.15 - [prefix IP].2.25 dan [prefix IP].2 .200 - [prefix IP].2.210

prefix IP IT19 = 10.73

Pada configurasi sebelumnya, tambahkan config yang sama pada bash untuk memberikan akses internet ke Atreides(Switch 2).

```
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

# Switch 2 - Atreides
subnet 10.73.2.0 netmask 255.255.255.0 {
	range 10.73.2.15 10.73.2.25;
	range 10.73.2.200 10.73.2.210;
	option routers 10.73.2.0;
	option broadcast-address 10.73.2.255;
	option domain-name-servers 10.73.3.2; # IP Irulan
}

# Switch 3
subnet 10.73.3.0 netmask 255.255.255.0 {}

# Switch 4
subnet 10.73.4.0 netmask 255.255.255.0 {}
}' > /etc/dhcp/dhcpd.conf


service isc-dhcp-server restart
```
Kemudian periksa apakah client di Atreides sudah dapat akses internet dengan `ping`.

#### 4. Client mendapatkan DNS dari Princess Irulan dan dapat terhubung dengan internet melalui DNS tersebut.

Setelah kita menjalankan bash pada soal sebelumnya, nodes yang ada pada switch 1 dan 2 seharusnya sudah mendapat akses internet melalui DHCP Server. Untuk melakukan cek kita akan ping salah satu domain di Irulan yaitu `atreides.it19.com`.

![](/image/1.png)

Client Dmitri sudah dapat mengakses DNS Irulan.

#### 5. Durasi DHCP server meminjamkan alamat IP kepada Client yang melalui `House Harkonen` selama 5 menit sedangkan pada client yang melalui `House Atreides` selama 20 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 87 menit.

Untuk itu kita akan menambahkan line pada bash config soal sebelumnya:

```
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
```

Sehingga akan muncul lease time setiap kita mengakses client:

![alt text](/image/2.png)

#### 6. setiap worker(harkonen) PHP, untuk melakukan konfigurasi virtual host untuk website yang telah disediakan dengan menggunakan `php 7.3`.

Untuk itu kita akan membuat bash untuk melakukan instalasi segala kebutuhan untuk setup setiap PHP Worker:

```
apt update
apt install nginx php-fpm php7.3 apache2 unzip lynx -y

mkdir /var/www/jarkom

curl -L --insecure "https://drive.google.com/uc?export=download&id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1" -o harkonen.zip

unzip harkonen.zip -d /var/www
rm harkonen.zip

mv /var/www/modul-3/* /var/www/jarkom/
rm -rf /var/www/modul-3

echo 'server {
    listen 80;
    root /var/www/jarkom;
    index index.php index.html index.htm;
    server_name _;
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
    }
    error_log /var/log/nginx/jarkom_error.log;
    access_log /var/log/nginx/jarkom_access.log;
}' >/etc/nginx/sites-available/jarkom.conf

ln -s /etc/nginx/sites-available/jarkom.conf /etc/nginx/sites-enabled/

rm /etc/nginx/sites-enabled/default

service nginx restart
service nginx status

service php7.3-fpm start
service php7.3-fpm status
```

Lalu cek salah satu web apakah sudah berhasil dijalankan dengan melakukan:
```
lynx http://10.73.1.3/
```
![alt text](/image/3.png)
diatas adalah tampilan jika berhasil.

#### 7. Aturlah agar `Stilgar` dari `Fremen` dapat dapat bekerja sama dengan maksimal, lalu lakukan testing dengan 5000 request dan 150 request/second.

Untuk membuat Stilgar menjadi Load Balancer, buat bash untuk melakukan instalasi keperluan Load Balancer:

```
apt-get update
apt-get install nginx php php-fpm lynx apache2-utils -y

echo 'upstream weight_round_robin  {
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}

server {
    listen 80;
        server_name harkonen.it19.com;

        root /var/www/harkonen.it19.com;
        index index.html index.htm index.nginx-debian.html;\

        location / {
            proxy_pass http://weight_round_robin;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/lb_error.log;
    access_log /var/log/nginx/lb_access.log;
}' > /etc/nginx/sites-available/balance_load

unlink /etc/nginx/sites-enabled/default

ln -s /etc/nginx/sites-available/balance_load /etc/nginx/sites-enabled/balance_load

service nginx restart
```

selanjutnya dengan menggunakan package `apache2-utils` kita akan mengirim 5000 request dan 150 request/second melalui client:

```
ab -n 5000 -c 150 http://10.73.4.2/
```

Hasilnya sebagai berikut:

![alt text](image/4.png)

Didapatkan hasil dengan 2635.82 request per second, selama 1.897 detik, dan terdapat 0 failed request

#### 8. Menuliskan peta tercepat menuju spice, lalu buatlah analisis hasil testing dengan 500 request dan 50 request/second masing-masing algoritma Load Balancer.

Ada empat jenis algortima load balancer yang digunakan pada pengerjaan nomor ini, yaitu:
1. Generic Hash
2. IP Hash
3. Least Connection
4. Round Robin

Sebelum itu kita tambahkan algortima yang akan digunakan dalam config Load Balancer:
```
apt-get update
apt-get install nginx php php-fpm lynx apache2-utils -y

echo 'upstream round_robin_workers {
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}

upstream least_conn_workers {
    least_conn;
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}

upstream ip_hash_workers {
    ip_hash;
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}

upstream generic_hash_workers {
    hash $request_uri;
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}

server {
    listen 80;
    server_name harkonen.it19.com;

    root /var/www/harkonen.it19.com;
    index index.html index.htm index.nginx-debian.html;\

    location /round_robin/ {
        proxy_pass http://round_robin_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /least_conn/ {
        proxy_pass http://least_conn_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /ip_hash/ {
        proxy_pass http://ip_hash_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /generic_hash/ {
        proxy_pass http://generic_hash_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
}' > /etc/nginx/sites-available/balance_load

unlink /etc/nginx/sites-enabled/default

ln -s /etc/nginx/sites-available/balance_load /etc/nginx/sites-enabled/balance_load

service nginx restart
```

Kemudian lakukan benchmark menggunakan `apache2-utils`:

1. Generic Hash
```
ab -n 500 -c 50 http://10.73.4.2/generic_hash
```
![alt text](image/5.png)

2. IP Hash
```
ab -n 500 -c 50 http://10.73.4.2/ip_hash/
```
![alt text](image/6.png)

3. Least Connection
```
ab -n 500 -c 50 http://10.73.4.2/least_conn/
```
![alt text](image/7.png)

4. Round Robin
```
ab -n 500 -c 50 http://10.73.4.2/round_robin/
```
![alt text](image/8.png)

Berikut adalah perbandingan Request per Second antar algoritma Load Balancer:
![alt text](/image/9.png)

#### 9. Dengan menggunakan algoritma Least-Connection, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 1000 request dengan 10 request/second, kemudian tambahkan grafiknya pada peta.

1. Dengan 3 Worker
```
ab -n 1000 -c 10 http://10.73.4.2/least_conn/
```
![alt text](image/10.png)

2. Dengan 2 Worker
```
ab -n 1000 -c 10 http://10.73.4.2/least_conn/
```
![alt text](image/11.png)

3. Dengan 1 Worker
```
ab -n 1000 -c 10 http://10.73.4.2/least_conn/
```
![alt text](/image/12.png)

Setelah dilakukan benchmark terhadap jumlah worker, didapatkan perbandingan sebagai berikut:

![alt text](image/13.png)

#### 10. Selanjutnya coba tambahkan keamanan dengan konfigurasi autentikasi di Load Balancer dengan dengan kombinasi username: `“secmart”` dan password: `“kcksit19”`. Terakhir simpan file `“htpasswd”` nya di `/etc/nginx/supersecret/`.

Untuk memberikan auth kita akan menambahkan config pada load balancer sebagai berikut:
```
mkdir -p /etc/nginx/supersecret
htpasswd -bc /etc/nginx/supersecret/htpasswd secmart kcksit19

echo 'upstream round_robin_workers {
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}

upstream least_conn_workers {
    least_conn;
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}

upstream ip_hash_workers {
    ip_hash;
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}

upstream generic_hash_workers {
    hash $request_uri;
    server 10.73.1.3;
    server 10.73.1.4;
    server 10.73.1.5;
}
server {
    listen 80;
    server_name harkonen.it19.com;

    root /var/www/harkonen.it19.com;
    index index.html index.htm index.nginx-debian.html;

    location /round_robin/ {
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
        proxy_pass http://round_robin_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /least_conn/ {
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
        proxy_pass http://least_conn_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /ip_hash/ {
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
        proxy_pass http://ip_hash_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /generic_hash/ {
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
        proxy_pass http://generic_hash_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}' > /etc/nginx/sites-available/balance_load

unlink /etc/nginx/sites-enabled/default

ln -s /etc/nginx/sites-available/balance_load /etc/nginx/sites-enabled/balance_load

service nginx restart
```

Setelah itu, coba masuk ke salah satu worker melalui client dan cek apakah terdapat auth:
```
lynx http://10.42.4.2/least_conn/
```
![alt text](/image/image.png)
![alt text](/image/image-1.png)
![alt text](/image/image-2.png)
![alt text](/image/image-3.png)

Setelah memasukkan Username dan Password yang telah di set pada bash, kita berhasil melakuakan login.

#### 11. Buat untuk setiap request yang mengandung `/dune` akan di proxy passing menuju halaman `https://www.dunemovie.com.au/`.

Kita akan menambahkan proxy passing pada config Load Balancer tadi:
```
    location /dune {
        rewrite ^/dune(.*)$ https://www.dunemovie.com.au$1 break;
        proxy_pass https://www.dunemovie.com.au;
        proxy_set_header Host www.dunemovie.com.au;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
```
Restart service nginx pada Load Balancer lalu cek melalui client:
```
lynx http://10.73.4.2/dune
```
![alt text](image/14.png)

#### 12. Load Balancer ini hanya boleh diakses oleh client dengan IP `[Prefix IP].1.37`, `[Prefix IP].1.67`, `[Prefix IP].2.203`, dan `[Prefix IP].2.207`.

Prefix IP IT19 = 10.73

Kita akan menambahkan `allow` dan `deny` pada config Load Balancer:
```
location / {
    allow 10.73.1.37;
    allow 10.73.1.67;
    allow 10.73.2.203;
    allow 10.73.2.207;
    allow 10.73.4.2;
    deny all;
}
```

Config ini akan menerima IP yang ada dalam daftar `allow` dan menolak semua yang tidak. Restart `nginx service` pada Load Balancer kemudian cek pada client menggunakan `lynx` dengan IP yang tidak ada dalam daftar `allow`. Berikut adalah contoh apabila IP tidak terdaftar:

![alt text](image/15.png)
