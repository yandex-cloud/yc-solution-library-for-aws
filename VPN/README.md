# Setting up VPN between AWS VPC  and Yandex VPC

## Overview and target scenario 
Sometimes you need to deploy VPN Site-To-Site connection between Yandex and VPN. You can use this example and module to set  it up.
Lets follow the example to see how its works

## Prerequisites

- Terraform 
- Configured AWS CLI and [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)  ( will be used for terraform credentials)



## Quick start




Initiate example playbook.  Please note that it uses "~/.ssh/id_rsa.pub" path for your public key



```
cd example
terraform init
terraform apply -var=cloud_id=$(yc config get cloud-id) -var=folder_id=$(yc config get folder-id) -var=token=$(yc config get token) 
```

