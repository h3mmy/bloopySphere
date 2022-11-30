#!/bin/bash
set -e

dt=$(date '+%d/%m/%Y %H:%M:%S');
fileDt=$(date '+%d_%m_%Y_%H_%M_%S');
backUpFileName="$KUBEGRES_RESOURCE_NAME-backup-$fileDt.gz"
backUpFilePath="$BACKUP_DESTINATION_FOLDER/$backUpFileName"

echo "$dt - Starting DB backup of Kubegres resource $KUBEGRES_RESOURCE_NAME into file: $backUpFilePath";
echo "$dt - Running: pg_dumpall -h $BACKUP_SOURCE_DB_HOST_NAME -U postgres -c | gzip > $backUpFilePath"

pg_dumpall -h $BACKUP_SOURCE_DB_HOST_NAME -U postgres -c | gzip > $backUpFilePath

if [ $? -ne 0 ]; then
    rm $backUpFilePath
    echo "Unable to execute a BackUp. Please check DB connection settings"
    exit 1
fi

echo "$dt - DB backup completed for Kubegres resource $KUBEGRES_RESOURCE_NAME into file: $backUpFilePath";

echo "$dt - Using dir $BACKUP_DESTINATION_FOLDER"
echo "$dt - removing all but last $RETENTION_COUNT entries"
numFiles=$(ls -t $BACKUP_DESTINATION_FOLDER | awk -v i=$RETENTION_COUNT 'NR>i' | wc -l)
echo "$dt - deleting $numFiles files"
rm `ls -t $BACKUP_DESTINATION_FOLDER | awk -v i=$RETENTION_COUNT 'NR>i'`
echo "$dt - done"
