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