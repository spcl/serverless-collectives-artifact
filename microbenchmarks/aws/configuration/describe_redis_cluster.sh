#!/bin/bash

name="sebs-communication-redis"

aws elasticache describe-cache-clusters --show-cache-node-info > redis_cluster.txt
aws ec2 describe-vpcs > vpcs.txt
aws ec2 describe-subnets > subnets.txt

echo "Connection endpoint for the Redis cluster"
jq -r '.CacheClusters[] | select(.CacheClusterId  == "sebs-communication-redis") | .CacheNodes[0].Endpoint' redis_cluster.txt

vpcs=$(jq -r '.Vpcs[] | select(.IsDefault == true) | .VpcId' vpcs.txt)
echo "VPC used by Lambda - in this one the S3 gateway: ${vpcs}"

group_id=$(jq -r '.SecurityGroups[] | select(.GroupName == "default") | .GroupId' security_groups.txt)
echo "Security group for lambda: ${group_id}"

subnets=$(jq -j '[.Subnets[] | .SubnetId] | join(",")' subnets.txt)
echo "Subnet IDs for Lambda: ${subnets}"

echo "Remember to add S3 gateway endpoint to VPC!"

