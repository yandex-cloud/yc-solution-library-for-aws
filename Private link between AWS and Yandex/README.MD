# Establishing a private link between AWS VPC and Yandex.Cloud
You can use AWS and Yandex.Cloud to establish a direct connection between clouds and route traffic through a private connection instead of the internet. This can help achieve the following goals:
* Increase connection security.
* Reduce traffic costs.
* Increase network performance and connection reliability.

Learn more about [AWS Direct Connect](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html) and [Yandex.Cloud InterConnect](https://cloud.yandex.com/docs/vpc/interconnect/).

## High-level diagram
Below you’ll find a high-level diagram of a private connection between AWS and Yandex.Cloud via a third-party partner: a telecom provider.

![Private link between AWS and Yandex Cloud Diagram](private_link_diagram.png "Private link between AWS and Yandex Cloud Diagram")

To establish a connection, you need to set up a configuration in both cloud consoles and work with a partner that can create the physical connection. 

## Configuration steps
To establish a connection, you need active AWS and Yandex.Cloud accounts.

1. Go to the [AWS console](https://console.aws.amazon.com/directconnect/v2/home)
2. Create a connection. You can find detailed instructions [here](https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-connection.html).  
3. Download the LOA-CFA document. [Detailed instructions.](https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-connection.html#create-connection-loa-cfa)
4. Send the document to a partner that will create the physical connection. A list of partners is provided below.
5. Go to the [Yandex.Cloud console](https://console.cloud.yandex.ru/) and create a support ticket to request Interconnect. The request must indicate the point of presence where the connection is set up and the connection bandwidth. If you set up a connection via a partner, enter the name of the partner company. You can learn more about this [here](https://cloud.yandex.com/docs/vpc/interconnect/). You can also ask your Yandex.Cloud account manager or solution architect to help.
6. Support will respond and help establish a configuration.
7. You can monitor the status of your connection in the AWS Console under **Connection**.
8. When the connection is established, you will need to create a virtual Interface in the AWS Console. You can learn more about how to do that [here](https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html).


## Partners 
The following partners can help establish connectivity:
1. [Retn](https://retn.net)
2. [Rascom](https://rascom.ru/en/)
3. [Telia Carrier](https://www.teliacarrier.com)

You can also speak with APN Direct Connect partners from [this list](https://aws.amazon.com/directconnect/partners/). 

## Direct Connect and Interconnect locations

### Yandex.Cloud Interconnect locations
* ММТС-9, Moscow, ul. Butlerova, 7
* StoreData, Moscow, ul. Nizhegorodskaya, 32, building A
* Dataline NORD, Moscow, Korovinskoe shosse, 41
* Dataline NORD, Moscow, Korovinskoe shosse, 41

### AWS Direct Connect locations
[List of AWS Direct Connect locations](https://aws.amazon.com/directconnect/features/#AWS_Direct_Connect_Locations)
