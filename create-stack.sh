REGION=$(aws configure get region)

if [ -z "$1" ]; then
      MODE=FARGATE
elif [ "$1" == "EC2" ]; then
      MODE=$1
elif [ "$1" == "FARGATE" ]; then
      MODE=$1
else
    echo "Wrong parameter 1 MODE: "$1
    exit 1 
fi


aws cloudformation create-stack --region $REGION --stack-name ecs-vpc-stack --template-body file://./ecs-vpc.yaml --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --region $REGION --stack-name ecs-vpc-stack

if [ "$MODE" == "FARGATE" ]; then
  aws cloudformation create-stack --region $REGION  --stack-name ecs-cluster-stack --template-body file://./ecs-fargate-cluster.yaml --capabilities CAPABILITY_IAM
elif [ "$MODE" == "EC2" ]; then
  aws cloudformation create-stack --region $REGION  --stack-name ecs-cluster-stack --template-body file://./ecs-ec2-cluster.yaml --capabilities CAPABILITY_IAM
fi
aws cloudformation wait stack-create-complete --region $REGION --stack-name ecs-cluster-stack

if [ "$MODE" == "FARGATE" ]; then
  aws cloudformation create-stack --region $REGION  --stack-name ecs-service-stack --template-body file://./ecs-fargate-service-elb-aas.yaml --capabilities CAPABILITY_IAM
elif [ "$MODE" == "EC2" ]; then
  aws cloudformation create-stack --region $REGION  --stack-name ecs-service-stack --template-body file://./ecs-ec2-service-elb-asg.yaml --capabilities CAPABILITY_IAM
fi

aws cloudformation wait stack-create-complete --region $REGION --stack-name ecs-service-stack
