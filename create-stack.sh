region=$(aws configure get region)


aws cloudformation create-stack --region $region --stack-name ecs-vpc-stack --template-body file://./ecs-vpc.yaml --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --region $region --stack-name ecs-vpc-stack
aws cloudformation create-stack --region $region  --stack-name ecs-cluster-stack --template-body file://./ecs-cluster.yaml --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --region $region --stack-name ecs-cluster-stack
aws cloudformation create-stack --region $region  --stack-name ecs-service-stack --template-body file://./ecs-service.yaml --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --region $region --stack-name ecs-service-stack
