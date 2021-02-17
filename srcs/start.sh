#!/bin/bash

apt-get update
apt-get upgrade
apt-get install -y nginx
apt-get install -y wget
apt-get install -y openssl
apt-get install -y mariadb-server
apt-get install -y php7.3 php7.3-fpm php7.3-mysql

rm -f /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

if [[ "$auto_index" == "off" ]]
then
	mv /files/nginx_config_off.conf /etc/nginx/sites-available/nginx_config.conf
else
	mv /files/nginx_config_on.conf /etc/nginx/sites-available/nginx_config.conf
fi
ln -s /etc/nginx/sites-available/nginx_config.conf /etc/nginx/sites-enabled/

mkdir /var/www/html/phpmyadmin && chown -R www-data:www-data /var/www/html/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
mv -v phpMyAdmin-4.9.0.1-all-languages/* /var/www/html/phpmyadmin/
mkdir /var/www/html/wordpress && chown -R www-data:www-data /var/www/html/wordpress
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv -v wordpress/* /var/www/html/wordpress/
openssl req -x509 -nodes -newkey rsa:4096 -days 365\
	-subj "/C=FR/ST=IDF/L=Paris/O=42/CN=yesmine"\
	-keyout /etc/ssl/private/sslkey.key -out /etc/ssl/certs/sslcertif.crt 

service nginx start	
service mysql start
service php7.3-fpm start

mysql -u root -e "create database wordpress"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'yesmine'@'localhost' IDENTIFIED BY 'yesmine';"
mysql -u root -e "FLUSH PRIVILEGES;"

service mysql restart

echo $auto_index
echo "daemon off;" >> /etc/nginx/nginx.conf
service nginx restart
#while true; do sleep 1d; done