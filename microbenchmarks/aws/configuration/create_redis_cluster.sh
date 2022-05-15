#!/bin/bash

name="sebs-communication-redis"

echo "Describing security groups"
aws ec2 describe-security-groups > security_groups.txt
group_id=$(jq -r '.SecurityGroups[] | select(.GroupName == "default") | .GroupId' security_groups.txt)
echo "Using default security group with ID ${group_id}"

echo "Creating cluster $name"
aws elasticache create-cache-cluster --cache-cluster-id $name --cache-node-type cache.t3.small --engine redis --num-cache-nodes 1 --security-group-ids ${group_id} > redis_cluster.txt

