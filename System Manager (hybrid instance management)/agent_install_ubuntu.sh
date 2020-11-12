#!/bin/bash

# That script should be run on Ubuntu instances (Intel 64-bit -x86_64) that you want to add to AWS System Manager as managed instances
# That script awaits Activation code and Activation ID from output of the initial_setup script as parameters

code=$1
id=$2
region="eu-central-1"

mkdir /tmp/ssm
sudo curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb -o /tmp/ssm/amazon-ssm-agent.deb
sudo dpkg -i /tmp/ssm/amazon-ssm-agent.deb
sudo service amazon-ssm-agent stop
sudo amazon-ssm-agent -register -code $code -id $id -region $region 
sudo service amazon-ssm-agent start