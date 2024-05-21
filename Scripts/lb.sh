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

    location / {
        allow 10.73.1.37;
        allow 10.73.1.67;
        allow 10.73.2.203;
        allow 10.73.2.207;
        allow 10.73.4.2;
        deny all;
    }

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
    
        location /dune {
        rewrite ^/dune(.*)$ https://www.dunemovie.com.au$1 break;
        proxy_pass https://www.dunemovie.com.au;
        proxy_set_header Host www.dunemovie.com.au;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}' > /etc/nginx/sites-available/balance_load

unlink /etc/nginx/sites-enabled/default

ln -s /etc/nginx/sites-available/balance_load /etc/nginx/sites-enabled/balance_load

service nginx restart

# lynx http://10.73.4.2/round_robin/
# lynx http://10.73.4.2/least_conn/
# lynx http://10.73.4.2/ip_hash/
# lynx http://10.73.4.2/generic_hash/

# ab -n 500 -c 150 http://10.73.4.2/generic_hash/
# ab -n 500 -c 150 http://10.73.4.2/ip_hash/
# ab -n 500 -c 150 http://10.73.4.2/least_conn/
# ab -n 500 -c 150 http://10.73.4.2/round_robin/