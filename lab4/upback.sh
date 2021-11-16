#!/usr/bin/env zsh

BACKUP_DIR="/home/$USER/Backup"
REPORT_FILE="/home/$USER/Backup/.backup_report"
SOURCE_DIR="/home/$USER/source"
RESTORE_DIR="/home/$USER/restore"

if ! [[ -d "$BACKUP_DIR" ]]; then echo "error, not found $BACKUP_DIR"; exit 1; fi
if ! [[ -d "$SOURCE_DIR" ]]; then echo "error, not found $SOURCE_DIR"; exit 1; fi
if ! [[ -e "$REPORT_FILE" ]]; then echo "error, not found $REPORT_FILE"; exit 1; fi

if [[ -d "$RESTORE_DIR" ]]
then 
    rm -rf $RESTORE_DIR
    mkdir $RESTORE_DIR 
else 
    mkdir $RESTORE_DIR 
fi

last_backup_dir=$(ls -1  "$BACKUP_DIR/" | grep -E "^Backup-*" | cut -d "-" -f 1,2,3,4 | sort -n -r -k3,4 | head -1)

if [[ -z $last_backup_dir ]]
then
    echo "not found Backup dir"
    exit 1
fi

for file in $(ls -1 "$BACKUP_DIR/$last_backup_dir" | grep -v -E "\.[0-9]{4}-[0-9]{2}-[0-9]{2}") 
do
    cp "$BACKUP_DIR/$last_backup_dir/$file" "$RESTORE_DIR/$file"
done
