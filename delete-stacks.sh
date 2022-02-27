#!/usr/bin/env bash

# Delete RDS
echo "Deleting Database Stack..."
aws cloudformation delete-stack --stack-name database
aws cloudformation wait stack-delete-complete --stack-name database

# Delete ALB, EC2
echo "Deleting Server Stack..."
aws cloudformation delete-stack --stack-name server
aws cloudformation wait stack-delete-complete --stack-name server

# Delete SecurityGroups
echo "Deleting Security Stack..."
aws cloudformation delete-stack --stack-name security
aws cloudformation wait stack-delete-complete --stack-name security

# Delete VPC, Subnets, InternetGateway, RoutingTables
echo "Deleting Netowrk Stack..."
aws cloudformation delete-stack --stack-name network
aws cloudformation wait stack-delete-complete --stack-name network

echo "Stack deletion completed"