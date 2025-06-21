#!/bin/bash

# === Variables ===
SOURCE_DIR="/home/ubuntu/mydata"
BACKUP_DIR="/tmp/backup"
S3_BUCKET="s3://my-backup-bucket"
LOG_FILE="/var/log/s3_backup.log"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
ARCHIVE_NAME="backup-$TIMESTAMP.tar.gz"
ENCRYPTED_ARCHIVE="$ARCHIVE_NAME.gpg"

# === Create archive ===
mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/$ARCHIVE_NAME -g $BACKUP_DIR/snapshot.file $SOURCE_DIR >> $LOG_FILE 2>&1

# === Optional: Encrypt backup ===
#gpg --symmetric --cipher-algo AES256 --batch --passphrase "MyStrongPass123" $BACKUP_DIR/$ARCHIVE_NAME
#rm $BACKUP_DIR/$ARCHIVE_NAME

# === Upload to S3 ===
aws s3 cp $BACKUP_DIR/$ARCHIVE_NAME $S3_BUCKET/ >> $LOG_FILE 2>&1

# === Cleanup ===
rm -f $BACKUP_DIR/$ARCHIVE_NAME
