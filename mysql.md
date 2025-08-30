CREATE DATABASE my_database;
CREATE USER 'my_user'@'localhost' IDENTIFIED BY 'my_password';
GRANT ALL PRIVILEGES ON my_database.* TO 'my_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

CREATE DATABASE wp_db;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'wp_password';
GRANT ALL PRIVILEGES ON wp_db.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
