#!/bin/bash

echo "Proceso: $1"
echo "Tarea: $2"
url="http://simple-cer.digital.gob.cl/integracion/especificacion/servicio/proceso/$1/tarea/$2"
echo "Url: $url"

resp=$(curl -H "Content-Type: application/json" -X GET $url)
echo "$resp" | python -m json.tool