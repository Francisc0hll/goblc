#!/bin/bash

echo "Proceso: $1"
echo "Tarea: $2"
echo "Params: $3"
url="http://simple-cer.digital.gob.cl/integracion/api/tramites/proceso/$1/tarea/$2"
echo "Url: $url"

resp=$(curl -d "$3" -H "Content-Type: application/json" -X POST $url)
echo "$resp" | python -m json.tool