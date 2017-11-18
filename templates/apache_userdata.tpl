#! /bin/bash

apt-get update
apt-get install apache2 -y

mkdir -p /var/log/tdcustom/accesslogs/
chown -R www-data:www-data ${log_path}
/etc/init.d/apache2 stop
sed -i 's#CustomLog.*#CustomLog\ ${log_path}/access.log\ combined#' /etc/apache2/sites-enabled/000-default.conf
chown -R www-data:www-data /var/log/apache2
chown -R www-data:www-data /usr/sbin/apache2
chmod u+s /usr/sbin/apache2
chown -R www-data:www-data /var/run/apache2
sed -i s'/Listen\ 80/Listen\ ${server_port}/' /etc/apache2/ports.conf
sed -i s'/\*:80/\*:${server_port}/' /etc/apache2/sites-enabled/000-default.conf

rm -rf /var/www/html/index.html

cat << 'EOF' >> /var/www/html/index.html
<html>
    <head>
        <title>TD Code Challenge</title>
    </head>
    <body>
        <h1>hello world! Coming to you live from apache</h1>
    </body>
</html>
EOF

chmod 600 /var/www/html/index.html
chown -R www-data:www-data /var/www/html/index.html

/etc/init.d/apache2 start