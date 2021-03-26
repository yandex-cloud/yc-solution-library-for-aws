
## Overview and target scenario 
This scenario specifically targets customers who have chosen Kubernetes as their base PaaS technology. These customers may have users in regions where AWS doesn't have data centers (such as Russia). To solve this issue, users can deploy a Kubernetes satellite cluster on Yandex.Cloud and add services from their clusters to the Global Service Management system.

For example, in this solution, you can have a main application installed on AWS and a satellite application installed on Yandex.Cloud. Both applications use Route 53 with regional forwarding, which forwards requests from the US to a US site and Russian requests to a Russian site.


<p align="center">
    <img src="https://storage.yandexcloud.net/cloud-www-assets/solutions/aws/yc-solution-library-aws-website-k8cloud.png" alt="Classic web-site diagram on multi-cloud" width="800"/>
</p>


You can add other solutions from this library. For example:
- The VPN solution to create secure channels between sites.
- RDS or AWS replication to sync data.
- [Kubefed](https://github.com/kubernetes-sigs/kubefed) to decentralize the Kubernetes federation control plane. Please note that KubeFed is currently in the alpha stage and not recommended for production use.


## Prerequisites

- Accounts in AWS and Yandex.Cloud
- Bash
- Terraform 0.13
- curl
- jq

Configure the AWS site:
- Configure AWS CLI.
- Install [AWS iam authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html).

Configure Yandex.Cloud:
- Configure the [Yandex Cloud CLI](https://cloud.yandex.com/docs/cli/quickstart).
- Export Yandex Cloud Credentials for Provider:

```
export YC_TOKEN=$(yc config get token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc resource-manager folder get --name=default --format=json | jq -r .id)
```
This example uses the 'default' folder for Yandex.Cloud.  


## Quick start


### Initiate an example playbook 


Please note that this uses the path ~/.ssh/id_rsa.pub for public keys:

```
cd example
terraform init
terraform apply # use -var=public_key_path='another_path_to_ssh_public_key' if you your ssh key is located somewhere else
```


### Wait about 10 minutes

If you have problems provisioning pods in the EKS cluster, use the commands below:


1) Get an AWS cluster name.
2) Configure cluster credentials and reapply terraform.

For example:
```
CLUSTER_NAME=`aws eks list-clusters --region us-west-1 | jq -r '.clusters[0]'`
aws eks --region us-west-1 update-kubeconfig --name $CLUSTER_NAME
terraform apply
```

### Check the result


You can run curl for both pods deployed in multiple clusters:

```
curl $(terraform output eks_lb_ip)
curl $(terraform output yc_lb_ip)
```

Check if the Route 53 Global DNS is working:

1) Go to the **AWS Console**.
2) Choose **Route 53 Service**.
3) Choose **aws-yandex-example.com**.
4) Click **Test Connection**.

Test the WWW record from different resolver addresses:

1) You can use a Google DNS IP address to emulate US client : 8.8.8.8.
2) You can use a Yandex IP address to emulate RU client: 87.250.250.1.
