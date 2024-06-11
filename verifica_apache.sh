DIR_NFS="/nfs/gabriel"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
SERVICE="httpd"
STATUS=$(systemctl is-active $SERVICE)

if [ "$STATUS" == "active" ]; then
    MESSAGE="ONLINE"
    echo "$DATE $SERVICE $STATUS $MESSAGE" >> $DIR_NFS/online.log
else
    MESSAGE="OFFLINE"
    echo "$DATE $SERVICE $STATUS $MESSAGE" >> $DIR_NFS/offline.log
fi