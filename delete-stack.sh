#!/bin/bash

REGION=$(aws configure get region)

aws cloudformation delete-stack --region $REGION --stack-name ecs-service-stack

if [ $? -ne 0 ]; then
  echo "Failed to delete ecs-service-stack"
  exit 1
fi


aws cloudformation wait stack-delete-complete --region $REGION --stack-name ecs-service-stack
aws cloudformation delete-stack --region $REGION --stack-name ecs-cluster-stack

if [ $? -ne 0 ]; then
  echo "Failed to delete ecs-cluster-stack"
  exit 1
fi

aws cloudformation wait stack-delete-complete --region $REGION --stack-name ecs-cluster-stack
#aws cloudformation delete-stack --region $REGION --stack-name ecs-vpc-stack
#aws cloudformation wait stack-delete-complete --region $REGION --stack-name ecs-vpc-stack


#Deregister Container Instances: Before you can delete a cluster, you must deregister the container instances inside that cluster. 
#For each container instance inside your cluster, follow the procedures in Deregister a Container Instance to deregister it.
#Alternatively, you can use the following AWS CLI command to deregister your container instances. 
#Be sure to substitute the Region, cluster name, and container instance ID for each container instance that you are deregistering.
#aws ecs deregister-container-instance --cluster default --container-instance container_instance_id --region us-west-2 --force



#Second time around it succeeds.
aws cloudformation delete-stack --region $REGION --stack-name ecs-cluster-stack

if [ $? -ne 0 ]; then
  echo "Failed to delete ecs-cluster-stack"
  exit 1
fi

aws cloudformation wait stack-delete-complete --region $REGION --stack-name ecs-cluster-stack
