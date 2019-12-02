#!/bin/bash

echo "Proceso: $1"
echo "Tarea: $2"
echo "Paso: $3"
url="http://simple-cer.digital.gob.cl/integracion/especificacion/formularios/proceso/$1/tarea/$2/paso/$3"
echo "Url: $url"

resp=$(curl -H "Content-Type: application/json" -X GET $url)
echo "$resp" | python -m json.tool