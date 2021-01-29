# Setting up two databases for replication



## Prerequisites

- Accounts in AWS and Yandex.Cloud
- Bash
- Terraform 0.14
- jq

To configre AWS Site
- Configure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) 
To configure Yandex.Cloud part
- Configure  [YC CLI](https://cloud.yandex.com/docs/cli/quickstart) 
- Export Yandex Cloud Credentials for Provider
```
export YC_TOKEN=$(yc config get token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

## Quick start

### Initiate example playbook.  


```
cd example
terraform init
terraform apply 
```

You will be promted for a password that will be set for sides. Please specify it , then write in somewhere secure

After you specified a password please wait for about 10 minutes for an example to start

When Database are set please get back to <a href="../README.md">scenario</a>


### To destroy everything quickly


```bash
terraform destroy
```