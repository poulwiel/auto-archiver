#!/bin/bash

FILE=$(find . -type f -mtime 30 -iregex "./[0-9]+\.[a-z]+" | sort | head -1)


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
    echo "pakowanie pliku $FILE udalo sie"
    SIZE=$(stat -c %s bakap.7z)
    if [ $SIZE -lt 150 ]
    then
        rm $FILE
        echo "pakowanie udalo sie, paczka jeszcze nie gotowa, usunalem plik $FILE , wywolam ogonowo"
        OGON=1
    else
        OGON=0
        if [ $BAKAP_EXISTS ]
        then
            rm bakap.7z
            mv bakap.7z_TEMP ElsevierJava.7z
            echo "FINAL: utworzono nowa paczke do nagrania!"
        else
            echo "ERROR: pierwzy dodawany plik $FILE stworzyl za duza paczke!"
        fi
    fi
else
    OGON=0
    echo "ERROR: pakowanie pliku $FILE nie udalo sie"
fi
if [ $OGON -eq 1 ]
then
    ./$0 &
    echo "OGON!"
else
    echo "STOP"
fi
exit 0
