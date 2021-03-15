# DynamoDB and YDB

Yandex DB features an API compatible with AWS DynamoDB. In this example, we’ll create an application that can perform database operations on AWS or Yandex databases depending on the process environment.

## Installing required software

Install [nodejs.](https://nodejs.org/)

Run `npm install` to install the required libraries.

## Setting up DynamoDB (local)

Install [DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html).

Prepare the environment:
```shell
export AWS_ENDPOINT=http://localhost:8000
export AWS_ACCESS_KEY_ID=fakeAccessKeyId
export AWS_SECRET_ACCESS_KEY=fakeSecretAccessKey
```

## Setting up DynamoDB (Web Service)

To get an access key, see [ Setting Up DynamoDB (Web Service)](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SettingUp.DynamoWebService.html).

Prepare the environment:
```shell
unset AWS_ENDPOINT # use default endpoint
export AWS_ACCESS_KEY_ID=#your access key id here
export AWS_SECRET_ACCESS_KEY=#your secret access key here
```

## Set up YDB

To create a serverless database, see [Creating a database](https://cloud.yandex.com/docs/ydb/quickstart/create-db). On the **Overview** tab, find **Document API endpoint**.

Create a [service account](https://cloud.yandex.com/docs/iam/operations/sa/create) and grant the `ydb.admin` role to the account.

Create [static access keys](https://cloud.yandex.com/docs/iam/operations/sa/create-access-key) for the account. Save the key ID and secret key.

Prepare the environment:
```shell
export AWS_ENDPOINT=#Document API endpoint
export AWS_ACCESS_KEY_ID=#your key id here
export AWS_SECRET_ACCESS_KEY=#your secret key here
```

## Running examples

Run `node create-table.js`. In the output, check the `TableStatus` value. 
If it’s Active, the table is ready for use; if it’s Creating, wait a short while and then run `node describe-table.js`. Repeat until the status is Active.

Add data to the table: run `node load-data.js`. It uses the BatchWriteItem operation to add a few items to the table.

Run `node scan.js` to view all items.
Run `node query.js` to only view items where species='cat'.

Run `node update,js` to update an existing item and `node delete-item.js` to delete one.

Run `node scan.js` again to see the changes in the table data.

Run `node delete-table.js`.
