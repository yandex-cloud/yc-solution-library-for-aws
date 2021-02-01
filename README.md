# Yandex.cloud and AWS integration pack
That repository containes a number of base blocks that will help developers and DevOps engeneers to build bybrid solutions between clouds. We tried to identify common tasks that developers will meet during architecturing or developing solutions and tried to describe best practises and provide examples of automation using terraform for this building blocks. Repository consists of description common scenarios and these modules:
1. <a href="/VPN/README.md">Automation for VPN between Yandex.Cloud and AWS</a>
2. <a href="/Database replication/README.md">Example of Database replication between Manged PostgreSQL and RDS using buildin logical replication</a>
3. <a href="/Kubernetes and route53/README.md)">Example of Kubernetes deployment between cloud and trafi rounting using global DNS</a>
4. <a href="/s3 Sync/README.md">Example of syncing Yandex object storage and AWS S3 based on Lambda functions</a>
5. <a href="/Multi-cloud storage with Yandex.Cloud and Amazon S3/README.md"> Guide how to establish multi cloud s3 compatible storage that distributes data between two Clouds  </a>
6. <a href="/System Manager (hybrid instance management)/README.MD">Example and automation for managing instances in Yandex.Cloud using AWS Systems Manager</a>
7. <a href="/Private link between AWS and Yandex/README.md">Guide how to establish Direct connection or private link between clouds</a>
8. <a href="/DynamoDB and YDB/README.md">Guide how to write an application in Yandex.Cloud which is Compatible with AWS Dynamodb</a>


We see more other blocks that could be added in repository and planning to add more of these. If you feel that we miss anything please reach out us and describe your scenario via Issues in that Github repository.

## Why we did
We see more and more customers start using different cloud for a different reasons, for instance:
1. Russian company want to start operate and work with customers outside for Russia and they want increase quality of service deploying additional services in outher cloud providers. That could be gaming companies where the latency is super importand, or e-commerce and etc.
2. Companies that want to start operate within the Russian border to encrease quality of service or become complint with local federal laws about private data.

To adress these scenarios we decided to implement best practises and automation for list of tasks that will help in this situations to bootstrap the development or deployment. Below you can find some common architecture patterns that could be developed using integration blocks examples in this repository but not limited to them. 

### **Web-site with independed deployment and global routing**
Thats an example of web-site that working independedly on both clouds to be more closly to the end users and be complient with local private data laws and rules. Routing established by global DNS routing based on Amazon Route53 that could route users based on thier GEO or latency parameters.
<p align="center">
    <img src="./images/classic-web-site.png" alt="Classic web-site diagram on multi-cloud" width="400"/>
</p>
You can find an example of setting up Route53 between Yandex cloud and AWS [here](link)


### **Web-site with depended databases or centralized database**
Thats more advanced example when you need for instance collect data in centralized place for further analisys or analytics 
<p align="center">
    <img src="./images/centralized-db.png" alt="Web-site with centralized DB" width="400"/>
</p>
Examples that could help to build that architecture:

* setting up replication between databases based on PostgreSQL <a href="/Database replication/README.md">here</a>

* also it could be beneficial to establish VPN connection for more secure connectivity. <a href="/VPN/README.md">Automation for VPN between Yandex.Cloud and AWS</a>

* or even establish a Direct Connect, example is <a href="/Private link between AWS and Yandex/README.md">here</a>

### **Centralized Data-Warehouse in AWS and app deployment in Yandex.Cloud**
Another common scenario is creating data-lake on AWS. Your Web-site or Application could opperate in different countries and cloud providers or regions but you will need to collect all information from distributed locations in one place. Below is an example of how that could be developed. Data with/out personalized attributes is created on Yandex cloud side and written on object storage withing the country border. After that object storage triggers the Yandex function that upload object to centralized object storage on AWS.  
<p align="center">
    <img src="./images/data-lake.png" alt="Centralized Data-lake or DataWarehouse" width="500"/>
</p>
Examples that could help to build that architecture:

* Yandex function that sync data between clouds, <a href="/s3 Sync/README.md">here</a>

* also it could be beneficial to establish VPN connection for more secure connectivity. VPN example is <a href="/VPN/README.md">here</a>

### **Kubernetes Applications on multi clouds**
Kubernetes is curretnly extremly popular techonology to build apps. That example could show you how you can build distributed app based on Kubernetes. The state of the app that stored in database could also be synced. You can also enrich that architecture by using [KubeFed project](https://github.com/kubernetes-sigs/kubefed) or Istio to establish federation of Kubernetes resources between clusters.    
<p align="center">
    <img src="./images/kubernetes.png" alt="Distributed Kubernetes app" width="500"/>
</p>
Examples that could help to build that architecture:

* [Kubernetes deployment between cloud and trafi rounting using global DNS](link)

* setting up replication between databases based on PostgreSQL <a href="/Database replication/README.md">here</a> 

* also it could be beneficial to establish VPN connection for more secure connectivity. VPN example is <a href="/VPN/README.md">here</a>

* KubeFed examples, [here](https://github.com/kubernetes-sigs/kubefed)

### **Centralized virtual machines fleet management**
In some cases your apps could work completly independetly and you dont need to sync states or data between deployment sites. But still you will need to operate and manage these apps and virtual machines. To simplify these management tasks:
* Patching
* Monitoring
* Access
* Inventory and etc
<p align="center">
    <img src="./images/management.png" alt="Fleet management" width="500"/>
</p>
Examples that could help to build that architecture:

* <a href="/System Manager (hybrid instance management)/README.MD">Example and automation for managing instances in Yandex.Cloud using AWS Systems Manager</a>

* VPN example is <a href="/VPN/README.md">here</a>

<br />

## Customer stories or examples

