#! /bin/bash

apt-get update
apt-get install nginx -y

rm -rf /usr/share/nginx/html/index.html

cat << 'EOF' >> /usr/share/nginx/html/index.html
<html>
	<head>
        <title>Aaron Lewis TD Code Challenge</title>
    </head>
    <body>
        <h1>hello world! Coming to you live from nginx</h1>
	</body>
</html>
EOF

chmod 600 /usr/share/nginx/html/index.html
chown -R www-data:www-data /usr/share/nginx/html/index.html

mkdir -p ${log_path}
chown -R www-data:www-data ${log_path}
/etc/init.d/nginx stop; sleep 15
chown www-data:www-data /usr/sbin/nginx
chmod u+s /usr/sbin/nginx
mkdir -p /var/run/nginx
chown -R www-data:www-data /var/run/nginx
sed -i 's#^pid.*$#pid\ /var/run/nginx/nginx.pid;#' /etc/nginx/nginx.conf
sed -i s'/listen\ 80\ default_server;/listen\ ${server_port}\ default_server;/' /etc/nginx/sites-enabled/default
sed -i s'/listen\ \[::\]:80/listen\ \[::\]:${server_port}/' /etc/nginx/sites-enabled/default
sed -i '/^server\ {/a \\taccess_log\ ${log_path}/access.log;' /etc/nginx/sites-enabled/default

/etc/init.d/nginx start