## Pre-requisite
- Install [terraform >= 1.5.7](https://www.terraform.io/downloads.html)
- Setup the [aws cli credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) 

## Setup

Apply the `remote_state` terraform project. This will create s3 bucket and lock table for keeping remote state for other tf projects.
cd st\terraform\state; terraform init; terraform apply


Apply the `ecs` terraform project. That will provision ECR repo/ ECS cluster/ Service/Task definition/ AutoScaling policy
cd st\terraform\ecs; terraform init; terraform apply

Apply the `networking` terraform project. That will provision VPC/ SecurityGroups/ 2 subnets /Target group/ LoadBalancer/ Listener / Route53 record
cd st\terraform\networking; terraform init; terraform apply

