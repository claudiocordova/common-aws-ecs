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

#Second time around it succeeds.
aws cloudformation delete-stack --region $REGION --stack-name ecs-cluster-stack

if [ $? -ne 0 ]; then
  echo "Failed to delete ecs-cluster-stack"
  exit 1
fi

aws cloudformation wait stack-delete-complete --region $REGION --stack-name ecs-cluster-stack
