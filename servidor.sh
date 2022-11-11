#!/bin/bash

PORT="2223"
SERVER_AD="localhost"

echo "Servidor Transfer Unite Recursive International Protocol: TURIP"

echo "(0) LISTEN: Handshake"

MSG=`nc -l $PORT`

HANDSHAKE=`echo $MSG | cut -d " " -f 1`
IP_CLIENT=`echo $MSG | cut -d " " -f 2`

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
FILE_NAME=`echo $MSG | cut -d " " -f 2`

echo "(7) SEND: Comprobación de FILE"

if [ "$ARCHIVO" != "FILE_NAME" ]
then
	echo "ERROR 2: File incorrecto"
	
	echo "KO_FILE_NAME" |nc $IP_CLIENT $PORT

	exit 2
fi

echo "OK_FILE_NAME" | nc $IP_CLIENT $PORT

echo "(8)LISTEN"

nc -l $PORT > inbox/$FILE_NAME



exit 0



