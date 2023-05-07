#!/usr/bin/sh

SUBNETS=subnet-3d3b6c57,subnet-5beb6927,subnet-1bb42557
SECURITY_GROUP=sg-4987103e

zip -ur build/smibenchmark.zip smi.json

# Creating function
aws lambda create-function \
--function-name smibenchmark_redis \
--region eu-central-1 \
--role arn:aws:iam::261490803749:role/lambda-vpc-role \
--runtime provided \
--timeout 600 \
--memory-size 2048 \
--handler smibenchmark \
--zip-file fileb://build/smibenchmark.zip \
--vpc-config SubnetIds=${SUBNETS},SecurityGroupIds=${SECURITY_GROUP} \
--output json > function_redis.json

