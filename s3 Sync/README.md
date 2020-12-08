# Description
TDB

# Limitations

TBD

# Syncyng two s3 buckets

Lets follow the example to see how its works


- Accounts in AWS and Yandex.Cloud
- Bash
- Terraform 
- [s3cmd](https://s3tools.org/download)
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
terraform apply -var=folder_id=$YC_FOLDER_ID

```



### Check the result

We will use 
- aws  as AWS site
- s3cmd as Yandex.Cloud site

lets prepare them

```
$ export BUCKET_NAME=$(terraform output bucket_name)
$ mv s3cfg ~/.s3cfg
```

Check that buckets are empty
```
$ aws s3 ls $BUCKET_NAME
$ s3cmd ls  s3://$BUCKET_NAME
```

put file to Yandex.Cloud bucket 

```
$ s3cmd put sync.zip s3://$BUCKET_NAME s3cmd put sync.zip s3://$BUCKET_NAME
upload: 'sync.zip' -> 's3://yc-s3-sync-a6v4g3vlra/sync.zip'  [1 of 1]
 2551 of 2551   100% in    0s    24.73 KB/s  done
```

check that file is on place

```
$ s3cmd ls  s3://$BUCKET_NAME
2020-12-08 18:41         2551  s3://yc-s3-sync-a6v4g3vlra/sync.zip
```

check that file is synced to AWS

```
$ aws s3 ls $BUCKET_NAME
2020-12-08 21:42:14       2551 sync.zip

```

### End the lab


```
$ aws s3 rm s3://$BUCKET_NAME/sync.zip
$ s3cmd rm s3://$BUCKET_NAME/sync.zip
$ terraform destroy -var=folder_id=$YC_FOLDER_ID
```


