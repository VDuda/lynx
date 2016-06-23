# Lynx

![LYNX](https://s3.amazonaws.com/uploads.hipchat.com/102551/2181055/IGXIWUrEoqX7tXF/lynx.png)

The lynx, has a prominent role in Greek, Norse, and North American mythology. It is considered an elusive and mysterious creature, known in some American Indian traditions as a 'keeper of secrets'. It is also believed to have supernatural eyesight, capable of seeing even through solid objects. As a result, it often symbolises the unravelling of hidden truths, and the psychic power of clairvoyance.


**Managing secrets in AWS**

Applications and Systems often need access to some shared credential. For example, titan needs access to the mongo database password, or some API token to access a third party service. At the moment we’re managing these secrets by storing them on a file. Using services like KMS and Dynamo we can create a centralized key store to manage secrets and keys without ever needing to persist the values on a machine.

![KMS Secret Architecture](https://s3.amazonaws.com/uploads.hipchat.com/102551/3053530/YURmeI0OIcLj8ta/upload.png)

More information available about KMS within their [white paper here](https://d0.awsstatic.com/whitepapers/KMS-Cryptographic-Details.pdf)

### Terraform

```
terraform plan -var-file=lynx.tfvars
# Verify changes
terraform apply -var-file=lynx.tfvars
```

#### Dynamo

Placing an item into the table

```
aws dynamodb put-item --table-name lynx-kms --item "{ \"name\": {\"S\": \"mysql_root\"}, \"value\": {\"S\": \"Password123\"} }"
```

Looking up table values

```
aws dynamodb scan --table-name lynx-kms
```

#### AWS IAM

Within AWS IAM, each IAM role will need to attach the policy "Access-Lynx" to have the ability read the encrypted passwords from the key store. The policy allows access to the key store and the cmk. The policy is strictly set to allow read-only access. 
