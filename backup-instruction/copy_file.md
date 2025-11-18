## copy folder from server to local computer
rsync -avzP root@212.85.24.184:/root/apps/pos.begunipik/dest/backup/ ~/Downloads/pos.begunipik/backup/

## copy folder from local computer to server
rsync -avzP ~/Downloads/pos.begunipik/backup/ root@212.85.24.184:/root/apps/pos.begunipik/dest/backup/ 


## copy nginx folder
rsync -avzP root@212.85.24.184:/root/apps/pos.begunipik/dest/ ~/Downloads/pos.begunipik/dest/
rsync -avzP root@212.85.24.184:/etc/nginx/ ~/Downloads/server/

rsync -avzP ~/Downloads/server/sites-available/ root@72.61.119.179:/etc/nginx/
rsync -avzP ~/Downloads/server/sites-enabled root@72.61.119.179:/etc/nginx/