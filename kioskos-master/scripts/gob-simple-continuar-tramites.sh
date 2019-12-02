#!/bin/bash

echo "Tramite: $1"
echo "Etapa: $2"
echo "Paso: $3"
echo "Params: $4"
url="http://simple-cer.digital.gob.cl/integracion/api/tramites/tramite/$1/etapa/$2/paso/$3"
echo "Url: $url"

resp=$(curl -d "$4" -H "Content-Type: application/json" -X PUT $url)
echo "$resp" | python -m json.tool