# AWS Systems Manager for hybrid managed instances
Systems Manager provides a unified user interface so you can view operational data from multiple managed instances across AWS, on-premises, and other cloud providers and allows you to automate operational tasks across your resources. With Systems Manager, you can group resources, view operational data for monitoring and troubleshooting, and audit operation changes for your groups of resources. Systems Manager simplifies resource and application management, shortens the time to detect and resolve operational problems, and makes it easy to operate and manage your infrastructure securely at scale.

Systems Manager securely communicates with a lightweight agent installed on your servers to execute management tasks. This helps you manage resources for Windows and Linux operating systems running on Amazon EC2, on-premises, and other cloud providers. You can read more about the service [here](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html).

Configuring your hybrid environment for Systems Manager enables you to do the following:
* Create a consistent and secure way to remotely manage your hybrid workloads from one location using the same tools or scripts.
* Centralize access control for actions that can be performed on your servers and VMs by using AWS Identity and Access Management (IAM).
* Centralize auditing and your view into the actions performed on your servers and VMs by recording all actions in AWS CloudTrail.
* For information about using CloudTrail to monitor Systems Manager actions, see Logging AWS Systems Manager API calls with AWS CloudTrail.
* Centralize monitoring by configuring EventBridge and Amazon SNS to send notifications about service execution success.


# Configuration 
To start managing instances deployed on Yandex Cloud, you first need to provision roles and make activation sessions with keys. To facilitate this, you can find the initial_setup.sh script, which will provision an IAM role to the SSM agent and grant the required permissions. It will also generate an Activation Key and ID that should be used on the managed instances during configuration.

## Initial setup
Clone the solution on the workstation [where the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) with credentials for your AWS account is installed.

Run the script from the terminal where you installed the AWS CLI:

```
./initial_setup.sh
```

The output will look something like this:

```
{
    "ActivationId": "27eb21d4-8611-4dee-8fd3-dc664b305773",
    "ActivationCode": "9a0Ls7VhsffdfDHxxxsqge"
}
```
Securely store the keys: you will use them to configure SSM agents.

## Adding a virtual machine to SSM
To add an instance to the SSM inventory, you need to run the script with the Activation Code and ID on the machines

For Linux (Ubuntu):

```
./agent_install_ubuntu.sh {Activation Code} {Activation ID}
```

For RHEL and CentOS:

```
./agent_install_RHEL_CentOS.sh {Activation Code} {Activation ID}
```

For Windows (with elevated privileges):

```
agent_install_windows.ps1 {Activation Code} {Activation ID}
```

## Checking an instance status in the AWS Console
Check the status of machines and manage them:
1. Go to the  [SSM console](https://eu-central-1.console.aws.amazon.com/systems-manager/)
2. Go to [Managed Instances](https://eu-central-1.console.aws.amazon.com/systems-manager/managed-instances?region=eu-central-1)
3. The console should look something like this: 

![Managed Instances](managed-ui.png "Managed Instances")
