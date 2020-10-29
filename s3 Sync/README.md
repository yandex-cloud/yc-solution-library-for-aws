# Syncyng two s3 buckets

Lets follow the example to see how its works

## Prerequisites

- Terraform 
- Configured AWS CLI and [YC CLI](https://cloud.yandex.com/docs/cli/quickstart) 
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
terraform apply -var=folder_id=$YC_FOLDER_ID

```


### End 

```
terraform destroy -var=folder_id=$YC_FOLDER_ID
```