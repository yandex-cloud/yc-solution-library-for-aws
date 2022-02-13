# Description

This scenario explains how to leverage [AWS Lambda](https://aws.amazon.com/lambda/) functions and [Yandex Cloud Functions](https://cloud.yandex.com/en-ru/docs/functions/) to sync newly created objects on [AWS S3](https://aws.amazon.com/s3/) and [Yandex Object Storage](https://cloud.yandex.com/en-ru/docs/storage/).

The example uses the same function code for both sides, as Yandex Cloud Functions and AWS Lambda runtimes are compatible.

If you look at the code, you’ll notice that it uses the same S3 API for both sides, as the AWS S3 and Yandex Storage APIs are compatible.


<p align="center">
    <img src="s3-sync.png" alt="S3 Synchronization diagram" width="800"/>
</p>

# Limitations

Please note that this example syncs only newly created objects. If you want some solution that helps with more scenarios out of the box please refer to <a href="../Multi-cloud S3 storage/README.md">Multi-cloud storage with Yandex Cloud and Amazon S3 guide</a>.


# Syncing two S3 buckets

Review the following example to see how syncing works.
You will need:

- Accounts in AWS and Yandex Cloud
- Bash
- Terraform 1.1.5
- [s3cmd](https://s3tools.org/download)
- jq

Configure the AWS site:
- Configure the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)


Configure Yandex Cloud:
- Configure the [YC CLI](https://cloud.yandex.com/docs/cli/quickstart) 
- Prepare the Terraform environment:

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export TF_VAR_folder_id=$YC_FOLDER_ID
```


## Quick start

### Initiate an example playbook  

```
cd example
terraform init
terraform apply
```

### Check results

We will use:
- `aws` tool for AWS site
- `s3cmd` tool for Yandex Cloud site

Prepare an environment:
```
BUCKET_NAME=$(terraform output -raw bucket_name)
mv s3cfg ~/.s3cfg
```

Make sure that AWS and Yandex Cloud buckets are empty:
```
aws s3 ls $BUCKET_NAME
s3cmd ls s3://$BUCKET_NAME
```

Put the file into the Yandex Cloud bucket:
```
s3cmd put sync.zip s3://$BUCKET_NAME 

upload: 'sync.zip' -> 's3://yc-s3-sync-a6v4g3vlra/sync.zip'  [1 of 1]
 2551 of 2551   100% in    0s    24.73 KB/s  done
```

Check that the file is in place at Yandex Cloud:
```
s3cmd ls s3://$BUCKET_NAME

2020-12-08 18:41         2551  s3://yc-s3-sync-a6v4g3vlra/sync.zip
```

Check that the file is successfully synced to the AWS S3:
```
aws s3 ls $BUCKET_NAME

2020-12-08 21:42:14       2551 sync.zip
```

### To destroy everything quickly

Delete all files at AWS and Yandex Cloud buckets:
```
aws s3 rm s3://$BUCKET_NAME/sync.zip
s3cmd rm s3://$BUCKET_NAME/sync.zip
rm ~/.s3cfg
```

Destroy Terraform resources:
```
terraform destroy
```
