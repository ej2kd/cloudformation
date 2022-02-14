#!/usr/bin/env bash

# Create VPC, Subnets, InternetGateway, RoutingTables
echo "Creating Network Stack..."
aws cloudformation create-stack --stack-name network --template-body file://0-network.yml
aws cloudformation wait stack-create-complete --stack-name network

# Create SecurityGroups for ALB, EC2, RDS
echo "Creating Security Stack..."
aws cloudformation create-stack --stack-name security --template-body file://1-security.yml \
--parameters ParameterKey=MyIpParameter,ParameterValue=$(curl -s ifconfig.me)
aws cloudformation wait stack-create-complete --stack-name security

# Create ALB, EC2
echo "Creating Server Stack..."
aws cloudformation create-stack --stack-name server --template-body file://2-server.yml \
--parameters ParameterKey=KeyName,ParameterValue=${KeyPairName}
aws cloudformation wait stack-create-complete --stack-name server

# Create RDS
echo "Creating Database Stack..."
aws cloudformation create-stack --stack-name database --template-body file://3-database.yml \
--parameters ParameterKey=DBName,ParameterValue=${MyDBName} ParameterKey=DBUserName,ParameterValue=${MyDBUserName} ParameterKey=DBPassword,ParameterValue=${MyDBPassword}
aws cloudformation wait stack-create-complete --stack-name database

echo "Stack creation completed"