REGION=$(aws configure get region)

aws cloudformation delete-stack --region $REGION --stack-name ecs-service-stack
aws cloudformation wait stack-delete-complete --region $REGION --stack-name ecs-service-stack
aws cloudformation delete-stack --region $REGION --stack-name ecs-cluster-stack
aws cloudformation wait stack-delete-complete --region $REGION --stack-name ecs-cluster-stack
aws cloudformation delete-stack --region $REGION --stack-name ecs-vpc-stack
aws cloudformation wait stack-delete-complete --region $REGION --stack-name ecs-vpc-stack


