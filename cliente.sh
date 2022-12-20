#!/bin/bash

IP_LOCAL="127.0.0.1"
PORT="2223"
SERVER_AD="localhost"

echo "Cliente TURIP"

echo "(1) SEND Handshake: HOLI_TURIP"

IP_MD5=`echo $IP_LOCAL | md5sum | cut -d " " -f 1`

echo "HOLI_TURIP $IP_LOCAL $IP_MD5" | nc $SERVER_AD $PORT

echo "(2) LISTEN: Comprobación Handshake"

MSG=`nc -l $PORT`

echo $MSG

if [ "$MSG" != "OK_TURIP" ]
then
	echo "ERROR 1: Handshake incorrecto"
	exit 1
fi

echo "(5)SEND Archivo: FILE_NAME"

FILE_NUM=`ls vacas | wc -l`
FILE_NUM_MD5=`echo $FILE_NUM | md5sum | cut -d " " -f 1`

echo "FILE_NAME $FILE_NUM $FILE_NUM_MD5" | nc $SERVER_AD $PORT
echo "$FILE_NUM"

echo "(6) LISTEN: Comprobación FILE"

MSG=`nc -l $PORT`

if [ "$MSG" != "OK_FILE_NAME" ]
then
	echo "ERROR 3: Nombre de archivo  incorrecto"
	exit 3
fi

for FILE in `ls ./vacas`
do
	FILE_NAME_MD5=`echo $FILE | md5sum | cut -d " " -f 1`
	echo "FILE_NAME $FILE $FILE_NAME_MD5" | nc $SERVER_AD $PORT

	echo "(9) LISTEN: Comprobación Archivo"
	MSG=`nc -l $PORT`

	if [ "$MSG" != "OK_FILE_NAME" ]
	then
		echo "ERROR 2: Nombre archivo incorrecto"
		exit 2
	fi

	echo "(10) SEND: Enviamos el archivo"
	cat vacas/$FILE | nc $SERVER_AD $PORT
done

exit 0

