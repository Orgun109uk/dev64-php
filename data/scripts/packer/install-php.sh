#!/bin/bash -e

MYSQLPASSWD="vagrant"

#######################################################################################################################
# Install MySQL.
echo mysql-server mysql-server/root_password password $MYSQLPASSWD | debconf-set-selections
echo mysql-server mysql-server/root_password_again password $MYSQLPASSWD | debconf-set-selections
apt-get install -y mysql-server mysql-client libmysqlclient-dev

touch /etc/mysql/conf.d/performance.conf
echo "[mysqld]" >> /etc/mysql/conf.d/performance.conf
echo "thread_cache_size = 16K" >> /etc/mysql/conf.d/performance.conf
echo "query_cache_size = 128M" >> /etc/mysql/conf.d/performance.conf
echo "query_cache_limit = 148M" >> /etc/mysql/conf.d/performance.conf
echo "key_buffer_size = 64M" >> /etc/mysql/conf.d/performance.conf
echo "tmp_table_size = 24M" >> /etc/mysql/conf.d/performance.conf
echo "max_heap_table_size = 24M" >> /etc/mysql/conf.d/performance.conf
echo "max_connection = 50" >> /etc/mysql/conf.d/performance.conf
echo "wait_timeout = 30" >> /etc/mysql/conf.d/performance.conf
echo "join_buffer_size = 4M" >> /etc/mysql/conf.d/performance.conf
echo "max_allowed_packet = 128M" >> /etc/mysql/conf.d/performance.conf
echo "connect_timeout = 10" >> /etc/mysql/conf.d/performance.conf
echo "skip-locking" >> /etc/mysql/conf.d/performance.conf
echo "skip-name-resolve" >> /etc/mysql/conf.d/performance.conf
echo "" >> /etc/mysql/conf.d/performance.conf

#######################################################################################################################
# Install Apache.
apt-get install -y apache2

a2enmod ssl
a2enmod rewrite

echo "" >> /etc/apache2/apache2.conf
echo "<IfModule mpm_prefork_module>" >> /etc/apache2/apache2.conf
echo "    StartServers          1" >> /etc/apache2/apache2.conf
echo "    MinSpareServers       1" >> /etc/apache2/apache2.conf
echo "    MaxSpareServers       3" >> /etc/apache2/apache2.conf
echo "    MaxClients           10" >> /etc/apache2/apache2.conf
echo "    MaxRequestsPerChild 3000" >> /etc/apache2/apache2.conf
echo "</IfModule>" >> /etc/apache2/apache2.conf
echo "" >> /etc/apache2/apache2.conf
echo "<IfModule mpm_worker_module>" >> /etc/apache2/apache2.conf
echo "    StartServers          1" >> /etc/apache2/apache2.conf
echo "    MinSpareThreads       5" >> /etc/apache2/apache2.conf
echo "    MaxSpareThreads      15 " >> /etc/apache2/apache2.conf
echo "    ThreadLimit          25" >> /etc/apache2/apache2.conf
echo "    ThreadsPerChild       5" >> /etc/apache2/apache2.conf
echo "    MaxClients           25" >> /etc/apache2/apache2.conf
echo "    MaxRequestsPerChild 200" >> /etc/apache2/apache2.conf
echo "</IfModule>" >> /etc/apache2/apache2.conf

sed -i.bak 's|^LogLevel = warn|LogLevel = error|' /etc/apache2/apache2.conf
sed -i.bak 's|^KeepAliveTimeout = 5|KeepAliveTimeout = 15|' /etc/apache2/apache2.conf

#######################################################################################################################
# Install PHP.
apt-get install -y php5 php5-dev php5-gd php5-mcrypt php5-cli php5-curl php5-mysql php5-xmlrpc libapache2-mod-php5 php5-xdebug

sed -i.bak 's|^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = E_ALL|' /etc/php5/apache2/php.ini
sed -i.bak 's|^display_errors = Off|display_errors = On|' /etc/php5/apache2/php.ini
sed -i.bak 's|^display_startup_errors = Off|display_startup_errors = On|' /etc/php5/apache2/php.ini
sed -i.bak 's|^max_execution_time = 30|max_execution_time = 240|' /etc/php5/apache2/php.ini
sed -i.bak 's|^memory_limit = 128M|memory_limit = 1024M|' /etc/php5/apache2/php.ini
sed -i.bak 's|^;error_log = syslog|error_log = syslog|' /etc/php5/apache2/php.ini
sed -i.bak 's|^;mail_log = syslog|mail_log = syslog|' /etc/php5/apache2/php.ini

sed -i.bak 's|^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = E_ALL|' /etc/php5/cli/php.ini
sed -i.bak 's|^display_errors = Off|display_errors = On|' /etc/php5/cli/php.ini
sed -i.bak 's|^display_startup_errors = Off|display_startup_errors = On|' /etc/php5/cli/php.ini
sed -i.bak 's|^max_execution_time = 30|max_execution_time = 240|' /etc/php5/cli/php.ini
sed -i.bak 's|^memory_limit = 128M|memory_limit = 1024M|' /etc/php5/cli/php.ini
sed -i.bak 's|^;error_log = syslog|error_log = syslog|' /etc/php5/cli/php.ini
sed -i.bak 's|^;mail_log = syslog|mail_log = syslog|' /etc/php5/cli/php.ini

echo "opcache.enable = 0" >> /etc/php5/mods-available/opcache.ini
echo "opcache.enable_cli = 0" >> /etc/php5/mods-available/opcache.ini
echo "opcache.revalidate_freq = 0" >> /etc/php5/mods-available/opcache.ini
echo "opcache.consistency_checks = 1" >> /etc/php5/mods-available/opcache.ini

updatedb
XDBG=$(locate xdebug.so)

sudo touch /etc/php5/apache2/conf.d/xdebug.ini
sudo chmod 777 /etc/php5/apache2/conf.d/xdebug.ini
echo "[xdebug]" >> /etc/php5/apache2/conf.d/xdebug.ini
echo "zend_extension = \"${XDBG}\"" >> /etc/php5/apache2/conf.d/xdebug.ini
echo "" >> /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.remote_enable = 1" >> /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.idekey = \"dev64-php-xdebug\"" >> /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.max_nesting_level = 200" >> /etc/php5/apache2/conf.d/xdebug.ini

#######################################################################################################################
# Install Memcache.
apt-get install -y php5-memcached memcached

sed -i.bak 's|^-m = 64|-m 1024|' /etc/memcached.conf
echo "" >> /etc/memcached.conf
echo "-I 32M" >> /etc/memcached.conf

#######################################################################################################################
# Setup the SSL keys.
make-ssl-cert generate-default-snakeoil --force-overwrite

#######################################################################################################################
# Install SSMTP
# http://askubuntu.com/a/368046
apt-get -y install ssmtp

sed -i.bak 's|^mailhub=mail|mailhub=0.0.0.0:1025|' /etc/ssmtp/ssmtp.conf

sed -i.bak 's|^;sendmail_path =|sendmail_path = /usr/sbin/sendmail -t|' /etc/php5/apache2/php.ini
sed -i.bak 's|^;sendmail_path =|sendmail_path = /usr/sbin/sendmail -t|' /etc/php5/cli/php.ini

#######################################################################################################################
# Install the Adminer.
echo "Download the Adminer script..."
wget http://downloads.sourceforge.net/adminer/adminer-4.2.1-mysql.php

echo "Setup the Adminer www root..."
mkdir /var/www/adminer
mv adminer-*-mysql.php /var/www/adminer/index.php

echo "Setup the Adminer vhost..."
touch /etc/apache2/sites-enabled/adminer.conf
chmod 667 /etc/apache2/sites-enabled/adminer.conf

echo "<VirtualHost *:8081>" >> /etc/apache2/sites-enabled/adminer.conf
echo "  DocumentRoot /var/www/adminer/" >> /etc/apache2/sites-enabled/adminer.conf
echo "  <Directory /var/www/adminer/>" >> /etc/apache2/sites-enabled/adminer.conf
echo "    Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-enabled/adminer.conf
echo "    AllowOverride All" >> /etc/apache2/sites-enabled/adminer.conf
echo "    Order allow,deny" >> /etc/apache2/sites-enabled/adminer.conf
echo "    Allow from all" >> /etc/apache2/sites-enabled/adminer.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/adminer.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/adminer.conf
echo "" >> /etc/apache2/sites-enabled/adminer.conf

echo "" >> /etc/apache2/ports.conf
echo "Listen 8081" >> /etc/apache2/ports.conf

a2dissite default

echo "Setup the default vhost..."
touch /etc/apache2/sites-enabled/default.conf
chmod 667 /etc/apache2/sites-enabled/default.conf

echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/default.conf
echo "  DocumentRoot /home/vagrant/workspace/" >> /etc/apache2/sites-enabled/default.conf
echo "  <Directory /home/vagrant/workspace/>" >> /etc/apache2/sites-enabled/default.conf
echo "    Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-enabled/default.conf
echo "    AllowOverride All" >> /etc/apache2/sites-enabled/default.conf
echo "    Order allow,deny" >> /etc/apache2/sites-enabled/default.conf
echo "    Allow from all" >> /etc/apache2/sites-enabled/default.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/default.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/default.conf
echo "" >> /etc/apache2/sites-enabled/default.conf

service mysql restart
service apache2 restart
service memcached restart
