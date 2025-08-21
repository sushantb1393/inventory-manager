#!/bin/bash
# script.sh - Create an EKS Cluster with eksctl

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
CLUSTER_NAME="mycluster"
REGION="us-east-1"
NODEGROUP_NAME="mynodes"
NODE_TYPE="t3.micro"
NODES=2
NODES_MIN=2
NODES_MAX=2

echo "🚀 Creating EKS Cluster: $CLUSTER_NAME in $REGION"

eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION" \
  --nodegroup-name "$NODEGROUP_NAME" \
  --node-type "$NODE_TYPE" \
  --nodes "$NODES" \
  --nodes-min "$NODES_MIN" \
  --nodes-max "$NODES_MAX" \
  --managed

echo "✅ Cluster $CLUSTER_NAME created successfully!"
