#!/bin/bash

PORT="2223"
SERVER_AD="localhost"

echo "Servidor Transfer Unite Recursive International Protocol: TURIP"

echo "(0) LISTEN: Handshake"

MSG=`nc -l $PORT`

HANDSHAKE=`echo $MSG | cut -d " " -f 1`
IP_CLIENT=`echo $MSG | cut -d " " -f 2`
IP_CLIENT_MD5=`echo $MSG | cut -d " " -f 3`

IP_MD5=`echo $IP_CLIENT | md5sum | cut -d " " -f 1`

if [ "$IP_CLIENT_MD5" != "$IP_MD5" ]
then
	echo "ERROR 1 : IP Cliente incorrecta"
	exit 1
fi

echo "(3) SEND: Comprobación"

if [ "$HANDSHAKE" != "HOLI_TURIP" ]
then 
	echo "ERROR 1: Handshake incorrecto"
	
	echo "KO_TURIP" | nc $IP_CLIENT $PORT

	exit 1
fi

echo "OK_TURIP" | nc $IP_CLIENT $PORT

echo "(4) LISTEN: FILE"
MSG=`nc -l $PORT`

ARCHIVO=`echo $MSG | cut -d " " -f 1`
FILE_NUM=`echo $MSG | cut -d " " -f 2`
FILE_NUM_MD5=`echo $MSG | cut -d " " -f 3`

NUM_FILES_MD5=`echo $FILE_NUM | md5sum | cut -d " " -f 1`

echo "(7) SEND: Comprobación de FILE"

if [ "$ARCHIVO" != "FILE_NAME" ]
then
	echo "ERROR 3: File incorrecto"
	
	echo "KO_FILE_NAME" |nc $IP_CLIENT $PORT

	exit 3
fi

echo "OK_FILE_NAME" | nc $IP_CLIENT $PORT

for FILE in `seq $FILE_NUM`

do
	echo "Escucha para el FILE_NAME"
	MSG=`nc -l $PORT`

	ARCHIVO=`echo $MSG | cut -d " " -f 1`
	NAME_FILE=`echo $MSG | cut -d " " -f 2`
	NAME_FILE_CL_MD5=`echo $MSG | cut -d " " -f 3`

	NAME_FILE_MD5=`echo $NAME_FILE | md5sum | cut -d " " -f 1`

	echo "(8)LISTEN : Datos de vaca"

	if [ "$NAME_FILE_MD5" != "$NAME_FILE_CL_MD5" ]
	then
		echo "ERROR 2: file name incorrect"
		echo "KO_FILE_NAME" | nc $IP_CLIENT $PORT
		exit 2
	fi

	echo "OK_FILE_NAME" | nc $IP_CLIENT $PORT

	echo "(9) LISTEN FILE CONTENT"
	nc -l  $PORT > inbox/$NAME_FILE
done

exit 0



