#!/usr/bin/sh
#
## Creating role
#aws iam create-role --role-name lambda-vpc-role --assume-role-policy-document file://trust-policy.json
#aws iam attach-role-policy --role-name lambda-vpc-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
#aws iam attach-role-policy --role-name lambda-vpc-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole

# Creating EC2 VM (group -> default VPC security group, incoming UDP connections on port 10,000 allowed)
#aws ec2 run-instances --image-id ami-07df274a488ca9195 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-06df67e1deee61365 --subnet-id subnet-02ace63723abfa440

# To get the IP
#aws ec2 describe-instances

# Compiling and packaging code into zip file
cd build && make aws-lambda-package-smibenchmark && zip -ur smibenchmark.zip ../smi.json && cd ..

# Updating code with newest zip
aws lambda update-function-code --region eu-central-1 --function-name smibenchmark_tcp --zip-file fileb://build/smibenchmark.zip
