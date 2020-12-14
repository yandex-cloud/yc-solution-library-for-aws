# Yandex.cloud and AWS integration pack
That repository containes a number of base blocks that will help developers and DevOps engeneers to build bybrid solutions between clouds. We tried to identify common tasks that developers will meet during architecturing or developing solutions and tried to describe best practises and provide examples of automation using terraform for this building blocks. Repository consists of description common scenarios and these modules:
1. [Automation for VPN between Yandex.Cloud and AWS](link)
2. [Example of Database replication between Manged PostgreSQL and RDS using buildin logical replication](link)
3. [Example of Kubernetes deployment between cloud and trafi rounting using global DNS](link)
4. [Example of syncing Yandex object storage and AWS S3 based on Lambda functions](link)
5. [Example and automation for managing instances in Yandex.Cloud using AWS Systems Manager](link)
6. [Guide how to establish Direct connection or private link between clouds](link)

We see more other blocks that could be added in repository and planning to add more of these. If you feel that we miss anything please reach out us and describe your scenario via Issues in that Github repository.

## Why we did
We see more and more customers start using different cloud for a different reasons, for instance:
1. Russian company want to start operate and work with customers outside for Russia and they want increase quality of service deploying additional services in outher cloud providers. That could be gaming companies where the latency is super importand, or e-commerce and etc.
2. Companies that want to start operate within the Russian border to encrease quality of service or become complint with local federal laws about private data.

To adress these scenarios we decided to implement best practises and automation for list of tasks that will help in this situations to bootstrap the development or deployment.

## Common scenarios where these building blocks will help

### Web-site with independed deployment and global monitoring and routing
### Web-site with depended databases or centralized database
### Centralized Data-Warehouse in AWS and app deployment in Yandex.Cloud
### Distributed Active Directory 

### 

### Data-lake


## Customer stories or examples

