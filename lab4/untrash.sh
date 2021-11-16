#!/bin/bash

trashLog="/home/$USER/.mytrash.log"
newTrashLog="/home/$USER/.newmytrash.log"
trash="/home/$USER/.mytrash"
deleteFileName="$1"

(cat $trashLog | grep -- "$deleteFileName") |
while read -r line
do 
    path=$(echo "$line" | awk '{print $1}')
    rmFile=$(echo "$line" | awk '{print $2}')
    
    echo "This is your file? (y/n) -" $path 
    read yorn < /dev/tty
    
    if [[ $yorn == "y" ]]
    then
        dirFile=$(dirname $path)
        fileName=$(echo $path | rev | cut -d'/' -f1 | rev)
        if [[ -d $dirFile ]]
        then
            if [[ -f $path ]]
            then
                echo "this file already exists, you need to rename"
                read newFileName < /dev/tty
                fileName=$newFileName
            fi
            ln "$trash/$rmFile" "$dirFile/$fileName" 
        
        else
            if [[ -f /home/$USER/$fileName ]]
            then
                echo "this file already exists, you need to rename"
                read newFileName < /dev/tty
                fileName=$newFileName
            fi
            ln "$trash$rmFile" "/home/$USER/$fileName" 
        fi

        rm -r -- "$trash/$rmFile"
        grep -v "${path} ${rmFile}" $trashLog > $newTrashLog
        cat $newTrashLog > $trashLog
        rm -r $newTrashLog
        break
    fi
done
