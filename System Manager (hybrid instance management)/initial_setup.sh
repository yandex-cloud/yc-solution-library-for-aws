#!/bin/bash
#
# Initial configuration that should be done in AWS account 
# That script will create a IaM role, attach policy that will allow AWS System manager to operate with SSM agent
# Also it will create Activation session and generate Activation code for smm agen on instances  
# That script could be run anywhere with IaM credentials that could create roles and have permissions to work with SSM


# Creating IaM role
aws iam create-role \
    --role-name SSMServiceRole \
    --assume-role-policy-document file://ssm-policy.json 

#Attaching policy to new role
aws iam attach-role-policy \
    --role-name SSMServiceRole \
    --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore  


#Create SSM Activation:
aws ssm create-activation \
  --default-instance-name yandex-cloud-vm\
  --iam-role SSMServiceRole \
  --registration-limit 100 \
  --region eu-central-1 \
  --tags "Key=Provider,Value=Yandex.Cloud"