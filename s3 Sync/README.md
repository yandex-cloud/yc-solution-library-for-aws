# Description

This scenario explains how to leverage AWS Lambda functions and Yandex Cloud Functions to sync newly created objects on AWS S3 and Yandex Object Storage.

The example uses the same function code for both sides, as Yandex Cloud Functions and AWS Lambda runtimes are compatible.

If you look at the code, you’ll notice that it uses the same S3 API for both sides, as the AWS S3 and Yandex Storage APIs are compatible.


<p align="center">
    <img src="https://storage.yandexcloud.net/cloud-www-assets/solutions/aws/yc-solution-library-aws-website-s3.png" alt="Classic web-site diagram on multi-cloud" width="800"/>
</p>

# Limitations

Please note that this example syncs only newly created objects. If you want some solution that helps with more scenarious out of the box please refer to <a href="../Multi-cloud S3 storage/README.md">Multi-cloud storage with Yandex.Cloud and Amazon S3 guide</a>.


# Syncing two S3 buckets

Review the following example to see how syncing works.
You will need:

- Accounts in AWS and Yandex.Cloud
- Bash
- Terraform 0.14
- [s3cmd](https://s3tools.org/download)
- jq

Configure the AWS site:
- Configure the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)


Configure Yandex.Cloud:
- Configure the [YC CLI](https://cloud.yandex.com/docs/cli/quickstart) 
- Export Yandex Cloud Credentials for Provider:

```
export YC_TOKEN=$(yc config get token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```


## Quick start

### Initiate an example playbook  

```
cd example
terraform init
terraform apply -var=folder_id=$YC_FOLDER_ID

```

### Check the result

We’ll use:
- aws  as AWS site
- s3cmd as Yandex.Cloud site

Prepare both sites:

```
export BUCKET_NAME=$(terraform output -json | jq -r '.bucket_name.value')
mv s3cfg ~/.s3cfg
```

Make sure the buckets are empty:
```
aws s3 ls $BUCKET_NAME
s3cmd ls  s3://$BUCKET_NAME
```

Put the file into the Yandex.Cloud bucket:

```
s3cmd put sync.zip s3://$BUCKET_NAME 
upload: 'sync.zip' -> 's3://yc-s3-sync-a6v4g3vlra/sync.zip'  [1 of 1]
 2551 of 2551   100% in    0s    24.73 KB/s  done
```

Check that the file is in place:

```
s3cmd ls  s3://$BUCKET_NAME
2020-12-08 18:41         2551  s3://yc-s3-sync-a6v4g3vlra/sync.zip
```

Check that the file is synced on AWS:

```
aws s3 ls $BUCKET_NAME
2020-12-08 21:42:14       2551 sync.zip

```

### End the lab

Delete all created objects:

```
aws s3 rm s3://$BUCKET_NAME/sync.zip
s3cmd rm s3://$BUCKET_NAME/sync.zip
rm ~/.s3cfg
```
Destroy the example.
```
terraform destroy -var=folder_id=$YC_FOLDER_ID
```


