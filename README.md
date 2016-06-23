# Lynx

![LYNX](https://s3.amazonaws.com/uploads.hipchat.com/102551/2181055/IGXIWUrEoqX7tXF/lynx.png)

**Managing secrets in AWS**

Applications and Systems often need access to some shared credential. For example, titan needs access to the mongo database password, or some API token to access a third party service. At the moment we’re managing these secrets by storing them on a file. Using services like KMS and Dynamo we can create a centralized key store to manage secrets and keys without ever needing to persist the values on a machine. 

![KMS Secret Architecture](https://s3.amazonaws.com/uploads.hipchat.com/102551/3053530/YURmeI0OIcLj8ta/upload.png)

More information available about KMS within their [white paper here](https://d0.awsstatic.com/whitepapers/KMS-Cryptographic-Details.pdf)
