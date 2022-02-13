
## Overview and target scenario 
This scenario specifically targets customers who have chosen Kubernetes as their base PaaS technology. These customers may have users in regions where AWS doesn't have data centers (such as Russia). To solve this issue, users can deploy a Kubernetes satellite cluster on Yandex Cloud and add services from their clusters to the Global Service Management system.

For example, in this solution, you can have a main application installed on AWS and a satellite application installed on Yandex Cloud. Both applications use Route 53 with regional forwarding, which forwards requests from the US to a US site and Russian requests to a Russian site.


<p align="center">
    <img src="kube-route53.png" alt="Kubernetes clusters at YC and AWS diagram" width="800"/>
</p>


## Prerequisites

- Accounts in AWS and Yandex Cloud
- Bash
- Terraform 1.1.5
- curl
- jq

Configure the AWS site:
- Configure the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

Configure Yandex Cloud:
- Configure the [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)
- Export Yandex Cloud configuration data for the Terraform provider:
```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

## Quick start

### Configure your public DNS domain name

Specify value for `aws_domain_name` variable at [variables.tf](example/variables.tf) file.

### Initiate an example playbook 

Please note that this uses the path ~/.ssh/id_rsa.pub for public keys:

```
cd example
terraform init
terraform apply # use -var=public_key_path='another_path_to_ssh_public_key' if you your ssh key is located somewhere else
```

and wait about 10 minutes.


### Check the result

You can run curl for both pods deployed in multiple clusters:

```
curl $(terraform output eks_lb_ip)
curl $(terraform output yc_lb_ip)
```

Check if the Route 53 Global DNS is working:

1) Go to the **AWS Console**.
2) Choose **Route 53 Service**.
3) Choose **aws-yandex-example.com**. (your public DNS name)
4) Click **Test Connection**.

Test the WWW record from different resolver addresses:

1) You can use a Google DNS IP address to emulate US client: 8.8.8.8
2) You can use a Yandex IP address to emulate RU client: 87.250.250.1
