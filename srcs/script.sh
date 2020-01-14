
service php7.3-fpm start
service mysql start
mysql -u root -bse "
CREATE DATABASE IF NOT EXISTS wordpress_db;
GRANT ALL ON wordpress_db.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'toor';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;"
nginx -g 'daemon off;'
bash