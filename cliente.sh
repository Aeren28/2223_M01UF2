#!/bin/bash

PORT="2223"
SERVER_AD="localhost"

echo "Cliente TURIP"

echo "(1) SEND Handshake: HOLI_TURIP"

echo "HOLI_TURIP 127.0.0.1" | nc $SERVER_AD $PORT

echo "(2) LISTEN: Comprobación Handshake"

MSG=`nc -l $PORT`

echo $MSG

if [ "$MSG" != "OK_TURIP" ]
then
	echo "ERROR 1: Handshake incorrecto"
	exit 1
fi

echo "(5)SEND Archivo: FILE_NAME"

echo "FILE_NAME vaca.vaca" | nc $SERVER_AD $PORT

echo "(6) LISTEN: Comprobación FILE"

MSG=`nc -l $PORT`






exit 0

