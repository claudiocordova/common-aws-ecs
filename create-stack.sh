#!/bin/bash

REGION=$(aws configure get region)

if [ -z "$1" ]; then
      MODE=ECS_FARGATE
elif [ "$1" == "ECS_EC2" ]; then
      MODE=$1
elif [ "$1" == "ECS_FARGATE" ]; then
      MODE=$1
else
    echo "Wrong parameter 1 MODE: "$1
    exit 1 
fi


#aws cloudformation create-stack --region $REGION --stack-name ecs-vpc-stack --template-body file://./ecs-vpc.yaml --capabilities CAPABILITY_IAM
#aws cloudformation wait stack-create-complete --region $REGION --stack-name ecs-vpc-stack

if [ "$MODE" == "ECS_FARGATE" ]; then
  aws cloudformation create-stack --region $REGION  --stack-name ecs-cluster-stack --template-body file://./ecs-fargate-cluster.yaml --capabilities CAPABILITY_IAM
  result=$?
elif [ "$MODE" == "ECS_EC2" ]; then
  aws cloudformation create-stack --region $REGION  --stack-name ecs-cluster-stack --template-body file://./ecs-ec2-cluster.yaml --capabilities CAPABILITY_IAM
  result=$?
fi



if [ $result -eq 254 ] || [ $result -eq 255 ]; then
  echo "ecs-cluster-stack already exists"
  #exit 0
elif [ $result -ne 0 ]; then
  echo "ecs-cluster-stack failed to create " $result
  exit 1
fi

aws cloudformation wait stack-create-complete --region $REGION --stack-name ecs-cluster-stack

if [ "$MODE" == "ECS_FARGATE" ]; then
  aws cloudformation create-stack --region $REGION  --stack-name ecs-service-stack --template-body file://./ecs-fargate-service-elb-aas.yaml --capabilities CAPABILITY_IAM
  result=$? 
elif [ "$MODE" == "ECS_EC2" ]; then
  aws cloudformation create-stack --region $REGION  --stack-name ecs-service-stack --template-body file://./ecs-ec2-service-elb-asg.yaml --capabilities CAPABILITY_IAM
  result=$?
fi



if [ $result -eq 254 ] || [ $result -eq 255 ]; then
  echo "ecs-service-stack already exists"
  #exit 0
elif [ $result -ne 0 ]; then
  echo "ecs-service-stack failed to create " $result
  exit 1
fi



aws cloudformation wait stack-create-complete --region $REGION --stack-name ecs-service-stack
