#!/bin/bash
KEYID="alias/lynx-edi"
VALUE=$(aws kms encrypt --key-id $KEYID --plaintext "$2" --query CiphertextBlob --output text)
/usr/bin/aws dynamodb put-item --table-name lynx-kms --item "{ \"name\": {\"S\": \"$1\"}, \"value\": {\"S\": \"$VALUE\"}  }"  --return-consumed-capacity TOTAL
