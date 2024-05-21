apt-get update
apt-get install mariadb-server -y
service mysql start

mysql <<EOF
CREATE USER 'it19'@'%' IDENTIFIED BY 'kcksit19';
CREATE USER 'it19'@'localhost' IDENTIFIED BY 'kcksit19';
CREATE DATABASE dbit19;
GRANT ALL PRIVILEGES ON *.* TO 'it19'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'it19'@'localhost';
FLUSH PRIVILEGES;
quit
EOF

mysql -u it19 -p'kcksit19' <<EOF
SHOW DATABASES;
quit
EOF

echo '[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
skip-networking=0
skip-bind-address' >/etc/mysql/my.cnf

service mysql restart