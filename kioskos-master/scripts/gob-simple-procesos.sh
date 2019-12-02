#!/bin/bash
url="http://simple-cer.digital.gob.cl/integracion/especificacion/procesos"
echo "Url: $url"

resp=$(curl -H "Content-Type: application/json" -X GET $url)
echo "$resp" | python -m json.tool