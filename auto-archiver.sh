#!/bin/bash

COUNT=$(find . -type f -mtime 30 -iregex "./[0-9]+\.[a-z]+" | wc -l)
echo "Matching files in this directory $COUNT"

FILE=$(find . -type f -mtime 30 -iregex "./[0-9]+\.[a-z]+" | sort | head -1)

if [ $COUNT -gt 0 ]
then

    if [ -f bakap.7z ]
    then
        BAKAP_EXISTS=1
    else
        BAKAP_EXISTS=0
    fi

    echo "BAKAP_EXISTS $BAKAP_EXISTS"

    if [ $BAKAP_EXISTS -eq 1 ]
    then
        cp bakap.7z bakap.7z_TEMP
    fi

    7z a -t7z -m0=lzma -mx=9 -mfb=64 bakap.7z $FILE

    if [ $? -eq 0 ]
    then
        echo "Adding file $FILE to archive succeded"
        SIZE=$(stat -c %s bakap.7z)

        if [ $SIZE -lt 4600000000 ]
        then
            rm $FILE bakap.7z_TEMP
            echo "Archive not big enought, file $FILE deleted, i will call myself recursively"
            TAIL=1
        else
            TAIL=0
            if [ $BAKAP_EXISTS ]
            then
                rm bakap.7z
                mv bakap.7z_TEMP ElsevierJava.7z
                echo "FINAL: archive file is ready to burn!"
            else
                echo "ERROR: first file $FILE in archive created to big archive!"
            fi
        fi

    else
        TAIL=0
        echo "ERROR: adding file $FILE failed!"
    fi

    if [ $TAIL -eq 1 ]
    then
        ./$0 &
        echo "TAIL!"
    else
        echo "STOP"
    fi

else
    echo "ERROR: no file to archive was found"
fi
exit 0
