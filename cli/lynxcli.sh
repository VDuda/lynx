#!/bin/bash
# Bash Menu Script Example
clear
echo "+------------------------------------------------------+"
echo "+------------------------------------------------------+"
echo "|                       Lynx CLI                       |"
echo "+------------------------------------------------------+"
echo "+------------------------------------------------------+"
echo ""
PS3='Please enter your choice: '
options=("Create Key/Pass" "Decrypt Key/Pass" "List all Keys" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create Key/Pass")
            echo "+------------------------------------------------------+"
            echo "|               Create new Key/Pass                    |"
            echo "+------------------------------------------------------+"
            workingdir=`pwd`
            workingdir+=/lynxkey
            lynxkey=`cat $workingdir`
            echo ""
            echo "Enter a Key Name"
            echo "-----------------------------------------"
            read keyname
            echo ""
            echo "Enter the Key's Password"
            echo "-----------------------------------------"
            read password
            echo ""
            echo $keyname, $password
            value=$(aws kms encrypt --key-id $lynxkey --plaintext "$password" --query CiphertextBlob --output text)
            echo $value
            aws dynamodb put-item --table-name lynx-kms --item "{ \"name\": {\"S\": \"$keyname\"}, \"value\": {\"S\": \"$value\"}  }"
            ;;
        "Decrypt Key/Pass")
            clear
            echo "+------------------------------------------------------+"
            echo "|                 Decrypt Key/Pass                    |"
            echo "+------------------------------------------------------+"
            echo ""
            echo "enter a Keyname to pull from database"
            echo "-----------------------------------------"
            read key
            response=$(aws dynamodb get-item --table-name lynx-kms --key "{\"name\":{\"S\":\"$key\"}}")
            #echo $response  | jq '[.[] | {User: .name.S, Pass:.value.S}]'
            encrypt=$(echo $response  | jq '.[] | .value.S' | cut -d '"' -f2)
            workingdir=`pwd`
            workingdir+=/blob
            echo "$encrypt" | base64 --decode > $workingdir
            finalpwd=$(aws kms decrypt --ciphertext-blob fileb://$workingdir --output text --query Plaintext | base64 --decode)
            echo "decrypted password is: $finalpwd"
            echo ""
            rm $workingdir

            ;;
        "List all Keys")
            clear
            echo "+------------------------------------------------------+"
            echo "|                     List all Keys                    |"
            echo "+------------------------------------------------------+"
            echo ""
            aws dynamodb scan --table-name lynx-kms | jq '[.Items[] | {Key: .name.S, Pass: .value.S}]'
            echo ""
            ;;
        "Quit")
            echo "Quitting..."
            clear
            break
            ;;
        *) echo invalid option;;
    esac
done
