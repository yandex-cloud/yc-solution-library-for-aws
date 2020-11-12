#!/bin/bash

# That script should be run on RHEL 8.x and CentOS 8.x instances that you want to add to AWS System Manager as managed instances
# That script awaits Activation code and Activation ID from output of the initial_setup script as parameters

code=$1
id=$2
region="eu-central-1"


mkdir /tmp/ssm
curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm -o /tmp/ssm/amazon-ssm-agent.rpm
sudo dnf install -y /tmp/ssm/amazon-ssm-agent.rpm
sudo systemctl stop amazon-ssm-agent
sudo amazon-ssm-agent -register -code $code -id $id -region $region 
sudo systemctl start amazon-ssm-agent