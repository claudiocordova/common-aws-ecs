region=$(aws configure get region)

aws cloudformation delete-stack --region $region --stack-name ecs-service-stack
aws cloudformation wait stack-delete-complete --region $region --stack-name ecs-service-stack
aws cloudformation delete-stack --region $region --stack-name ecs-cluster-stack
aws cloudformation wait stack-delete-complete --region $region --stack-name ecs-cluster-stack
aws cloudformation delete-stack --region $region --stack-name ecs-vpc-stack
aws cloudformation wait stack-delete-complete --region $region --stack-name ecs-vpc-stack


