# Setting up replication between AWS RDS for PostgreSQL and Yandex Managed Database

## Overview and target scenario
We’ve noticed that more and more customers are looking for approaches to help them build hybrid solutions. While the reasons for this include a need to comply with local regulations and meet latency requirements, others use AWS for primary deployment and consolidating data. To help our customers, we tested replication between AWS RDS for PostgreSQL version 12.3 and Managed Service for PostgreSQL version 12 and prepared detailed step-by-step instructions for the scenario. Here you’ll find the official documentation for logical replication in PostgreSQL, which the solution is built on. The deployment architecture is illustrated below:


<p align="center">
    <img src="https://storage.yandexcloud.net/cloud-www-assets/solutions/aws/yc-solution-library-aws-website-replication-db.png" alt="Classic web-site diagram on multi-cloud" width="600"/>
</p>

A detailed description of a similar process between PostgreSQL instances deployed on AWS can be found [here](https://aws.amazon.com/blogs/database/using-logical-replication-to-replicate-managed-amazon-rds-for-postgresql-and-amazon-aurora-to-self-managed-postgresql/). The process consists of two stages:
1. Initial setup of the logical replication slot and initial data backup.
2.	Establishing ongoing replication of changes using the pgoutput plugin.

## Prerequisites

1.	Deploy a new RDS database instance on your AWS account. Detailed instructions can be found [here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.CreatingConnecting.PostgreSQL.html).
`Note: You need to setup public access for the host.`
2.	Deploy a new Yandex Managed Service for PostgreSQL instance. You can also use your current deployment. Detailed instructions on how to deploy it can be found [here](https://cloud.yandex.ru/docs/managed-postgresql/quickstart). 
`Note: You need to setup public access for the host.`
3. Configure a security group for the RDS instance to allow inbound and outbound traffic from the Yandex Managed Database host’s IP address. The IP address can be found using the hostname from the connection string provided in the Yandex Web Console.  
For example: `port:5432, ip:84.201.177.214/32, protocol:TCP`.

## Setting up replication

### Yandex Database
1.	Grant permissions to the user performing replication. This can be done by running the following command in the Yandex CLI:

```
yc managed-postgresql user update {user_name} --grants mdb_replication --cluster-id {cluster_id}
```

2.	Create a test table:

```
CREATE TABLE phone(phone VARCHAR(32), firstname VARCHAR(32), lastname VARCHAR(32);
```

3.	Insert test data:

```
INSERT INTO phone(phone, firstname, lastname) VALUES ('12313213', 'Jack', 'Jackinson')
```

4.	Create a publication:

```
CREATE PUBLICATION yandex_pub FOR TABLE phone;
```


### AWS RDS for PostgreSQL
1. Create a new parameters group. Assign the rds.logical_replication parameter a value of 1. Attach it to your database instance. Detailed instructions on how to create parameter groups can be found [here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html).
2. To establish replication, the same tables must be available in the read replica instance. To do this, you can use pg_dump and restore it, or in our case, create the same empty table:
```
CREATE TABLE phone(phone VARCHAR(32), firstname VARCHAR(32), lastname VARCHAR(32);
```
3. Create a subscription to the changes in the original database using your user credentials:
```
СREATE SUBSCRIPTION yandex_sub CONNECTION 'host={xxxxxxxxx.mdb.yandexcloud.net} port=6432 dbname=db1 user={xxxx} password={xxxxxxx}' PUBLICATION yandex_pub;
```

### Testing replication
1.	Once you’ve successfully completed the previous steps, you should be able to see the initial data in your AWS read replica instance. Try to execute the following command on the AWS read replica instance: `select * from phone`. This should show you the initial data from your original Yandex database. From now on, all changes to data in the original database will be replicated on the read replica in AWS. 
2. Try inserting a new row in the original database and then see if the same changes were made on the read replica:
```
INSERT INTO phone(phone, firstname, lastname) VALUES ('444444, 'Alex', 'Trump')
```

You can also check the status of replication slots in the original database using the following query: select * from pg_replication_slots; The query should return something like this: 

slot_name |  plugin  | slot_type | datoid | database | temporary | active | active_pid | xmin | catalog_xmin | restart_lsn | confirmed_flush_lsn 
-----------|----------|-----------|--------|----------|-----------|--------|------------|------|--------------|-------------|---------------------
 mysub     | pgoutput | logical   |  13934 | postgres | f         | t      |      31772 |      |          661 | 0/12016490  | 0/120164C8


Use the following command in a query to help you check the current replication progress and get replication statistics: `select * from pg_stat_replication;`

### Replicating all tables
1.	To replicate all of the tables in your database, both databases must have similar schemas. The easiest way to copy schemas is to use the command `pg_dump --schema-only.` and apply it on the read replica. 
2. Create a publication:  `CREATE PUBLICATION yandex_pub FOR ALL TABLES`
3. The process is then the same as the instructions above.

### Limitations
A detailed explanation of all replication restrictions and limitations can be found [here](https://www.postgresql.org/docs/10/logical-replication-restrictions.html). The main restrictions are:
* The database schema and DDL commands can’t be replicated. The initial schema can be copied manually using  pg_dump --schema-only. . Any changes to the schema will need to be made on replicas manually. (Note that schemas don’t have to be absolutely identical on both sides.) Logical replication is robust when schema definitions change in a live database: when the schema is changed on the publisher and replicated data starts arriving at the subscriber, but doesn’t fit into the table schema, replication will cause an error to occur until the schema is updated. In many cases, you can avoid intermittent errors by first applying additive schema changes to the subscriber.
* Sequence data can’t be replicated. Data in serial or identity columns backed by sequences will be replicated as part of the table, but the sequence itself will still show the start value on the subscriber. If the subscriber is used as a read-only database, then this generally shouldn’t be a problem. If, however, a switchover or failover to the subscriber database is planned, then the sequences will have to be updated to the latest values either by copying the current data from the publisher (using pg_dump, for example) or by setting an initial value that will certainly be higher than possible values in the source database.
* TRUNCATE commands can’t be replicated. A workaround for this is to use DELETE instead. To avoid accidental TRUNCATE invocations, revoke the TRUNCATE privilege from the tables.
* Large objects (see Chapter 34) can’t be replicated. There is no workaround for that other than to store data in normal tables.
* Replication is only possible from base tables to base tables: the tables on publication and subscription sides must be normal tables, but not views, materialized views, partition root tables, or foreign tables. For partitions, you can replicate a partition hierarchy one-to-one, but you currently can’t replicate to a differently partitioned setup. Attempts to replicate tables other than base tables will result in an error.

### Using AWS Database Migration Service
The current version of the AWS Database Migration Service uses the pglogical extension to sync data between PostgreSQL databases. Unfortunately, Yandex Managed Database for PostgreSQL doesn’t have that extension. Therefore, ongoing replication cannot be established, but you can still use the service for one-time migration. You can find detailed instructions on how to use the AWS Database Migration Service to establish replication between PostgreSQL databases [here](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_SettingUp.html).   
