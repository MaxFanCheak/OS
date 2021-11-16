#!/usr/bin/env zsh

trashLog="/home/$USER/.mytrash.log"
trash="/home/$USER/.mytrash"
nameFile="$1"

if ! [[ -f $nameFile ]]
then
    echo "File doesn't found"
    exit 1
fi

if ! [[ -d $trash ]]
then
    mkdir $trash
fi

currentDate=$(date '+%s%N')

path_file=$(realpath "$nameFile")

ln -- "${path_file}" "$trash/$currentDate" && rm -r -- $path_file && echo $path_file $currentDate >> $trashLog  
