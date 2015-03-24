mysql_password=$(cat /dev/urandom| tr -dc 'a-zA-Z0-9' | fold -w 10| head -n 1)

yum -y update
yum -y install git nginx php-fpm mysql-server mysql

### Nginx setup
mkdir /etc/nginx/global
mkdir /etc/nginx/sites-enabled
cp files/nginx.conf /etc/nginx/
cp files/restrictions.conf /etc/nginx/global/
cp files/wordpress.conf /etc/nginx/global/
cp files/mfb.com.conf /etc/nginx/sites-enabled/montessorifrombirth.com

### php setup
cp files/www.conf /etc/php-fpm.d/

### Mysql setup
/usr/bin/mysqladmin -u root password "$mysql_password"
/usr/bin/mysqladmin -u root --password="$mysql_password" -h $(hostname) "$mysql_password"

### Wordpress setup
curl -k https://wordpress.org/latest.tar.gz -O
tar -xzvf latest.tar.gz
mv wordpress /var/www/mfb
cat files/wp-config.php | sed "s/~~mysql_password~~/$mysql_password/g" > /var/www/mfb/wp-config.php

chown -R ec2-user:ec2-user /var/www/mfb

chkconfig nginx on
chkconfig php-fpm on
chkconfig mysqld on

service nginx restart
service php-fpm restart
