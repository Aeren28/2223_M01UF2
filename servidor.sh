#!/bin/bash

echo "Servidor Transfer Unite Recursive International Protocol: TURIP"

echo "(0) LISTEN"
MSG=`nc -l 2223`

if [ "$MSG" != "HOLI_TURIP" ]
then 
	echo "ERROR 1: Handshake incorrecto"
	exit 1
fi

