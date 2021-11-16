#!/bin/bash

BACKUP_DIR="/home/$USER/Backup"
REPORT_FILE="/home/$USER/Backup/.backup_report"
SOURCE_DIR="/home/$USER/source"

if ! [[ -d "$BACKUP_DIR" ]]; then mkdir -p $BACKUP_DIR; fi
if ! [[ -d "$SOURCE_DIR" ]]; then mkdir $SOURCE_DIR; fi
if ! [[ -e "$REPORT_FILE" ]]; then touch $REPORT_FILE; fi

currentDate=$(date '+%Y-%m-%d')
last_backup_date=$(ls -1 "$BACKUP_DIR/" | grep -E "^Backup-*" | cut -d "-" -f 2,3,4 | sort -n -r | head -1)
last_backup_dir=$(ls -1  "$BACKUP_DIR/" | grep -E "^Backup-*" | cut -d "-" -f 1,2,3,4 | sort -n -r -k3,4 | head -1)

currentDate_sec=$(date -d "$currentDate" "+%s")
last_backup_date_sec=$(date -d "$last_backup_date" "+%s")

backup_dir_name="Backup-"${currentDate}
backup_dir_path="/home/$USER/Backup/${backup_dir_name}"

day_time=$(echo "(${currentDate_sec} - ${last_backup_date_sec}) / 86400" | bc)

if [[ $day_time -lt 7 && "$last_backup_dir" != "" ]]
then
    for file in $(ls -1 "${SOURCE_DIR}")
    do
        if [[ -f "$SOURCE_DIR/$file" ]]
        then
            if [[ -f $BACKUP_DIR/Backup-$last_backup_date/$file ]]
            then
                size_newFile=$(du -b "$SOURCE_DIR/$file" | awk '{print $1}')
                size_oldFile=$(du -b "$BACKUP_DIR/Backup-$last_backup_date/$file" | awk '{print $1}')
                size=$(echo "$size_newFile - $size_oldFile" | bc)
                if [ $size -ne 0 ]
                then
                    mv "$BACKUP_DIR/$last_backup_dir/$file"  "$BACKUP_DIR/$last_backup_dir/$file.$currentDate"
                    cp -v "$SOURCE_DIR/$file" "$BACKUP_DIR/$last_backup_dir" >> $REPORT_FILE
                fi
            else
                cp -v "$SOURCE_DIR/$file" "$backup_dir_path/" >> $REPORT_FILE
            fi
        fi
    done
else
    (mkdir ${backup_dir_path} && echo "${currentDate} : backup directory ${backup_dir_path}" || echo "${currentDate} : error create directory")  >> $REPORT_FILE
    cp -rv "$SOURCE_DIR/"* "$backup_dir_path" >> $REPORT_FILE
fi

