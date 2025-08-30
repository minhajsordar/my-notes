### credintial
root@142.93.236.178
Password: BgfynB5!4F1u

### get backup to local machine
rsync -avzP root@142.93.236.178:/var/www/ ~/Downloads/www_backup/
rsync -avzP root@142.93.236.178:/var/etc/ ~/Downloads/etc_backup/



rsync -avzP root@142.93.236.178:/var/www/payment.easyonwardticket.com/ ~/Downloads/www_backup/payment.easyonwardticket.com/

rsync -avzP root@142.93.236.178:/var/www/html/ ~/Downloads/www_backup/html/
rsync -avzP root@142.93.236.178:/var/www/admin_onwardticket/ ~/Downloads/www_backup/admin_onwardticket/

rsync -avzP root@142.93.236.178:/var/www/ssadmin.easyonwardticket.com/ ~/Downloads/www_backup/ssadmin.easyonwardticket.com/

ssadmin.easyonwardticket.com and payment.easyonwardticket.com


rsync -avzP ~/Downloads/www_backup/ssadmin.easyonwardticket.com/ root@142.93.236.178:/var/www/ssadmin.easyonwardticket.com/
rsync -avzP ~/Downloads/www_backup/payment.easyonwardticket.com/ root@142.93.236.178:/var/www/payment.easyonwardticket.com/


rsync -avzP /Applications/XAMPP/xamppfiles/htdocs/www_backup/ssadmin.easyonwardticket.com/ root@142.93.236.178:/var/www/ssadmin.easyonwardticket.com/

rsync -avzP /Applications/XAMPP/xamppfiles/htdocs/www_backup/payment.easyonwardticket.com/ root@142.93.236.178:/var/www/payment.easyonwardticket.com/

scp ~/Downloads/database_backup.sql root@142.93.236.178:~/dbbackup/

CREATE DATABASE easyonward_client;
CREATE USER 'easyonwarduser'@'localhost' IDENTIFIED BY 'fqtL9ZfRbPfEzez';
GRANT ALL PRIVILEGES ON easyonward_client.* TO 'easyonwarduser'@'localhost';
FLUSH PRIVILEGES;
EXIT;

mysql -u easyonwarduser -p easyonwarddb < ~/dbbackup/database_backup.sqlT

