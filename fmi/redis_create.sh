#!/usr/bin/sh
#
# Take a default secruity grupy from the account
aws elasticache create-cache-cluster --cache-cluster-id ClusterForLambda --cache-node-type cache.t3.small --engine redis --num-cache-nodes 1 --security-group-ids sg-4987103e --region eu-central-1
