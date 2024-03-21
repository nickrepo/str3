resource "aws_ecr_repository" "str_ecr" {
  name                 = "strecrrepo1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "cluster-${var.env}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "str_task" {
  family = "hello-world"
  #execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "Strat7"
      image     = "public.ecr.aws/nginx/nginx:mainline-alpine3.18-perl"
      essential = true

      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"
  cpu          = "256"
  memory       = "512"
}

resource "aws_ecs_service" "STR_ECS_service" {
  name            = "hello-world"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.str_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = data.aws_lb_target_group.LB_tg.arn
    container_name   = "Strat7"
    container_port   = 80
  }

  network_configuration {
    // Using public subnet, as private subnet would require NAT Gateway/VPC Endpoints for AWS ECR for fetching images.
    // Internet Gateway is free but not the NAT Gateway/VPC Endpoint.
    // Restricting access to the instances can be done by SG itself.
    // No point in incurring charges for NAT (~ 3 INR/hr) /VPC Endpoint (~ 0.7 INR/hr)just for this assignment.
    subnets          = [data.aws_subnet.stratsub1.id, data.aws_subnet.stratsub2.id]
    assign_public_ip = true
    security_groups  = [data.aws_security_group.ecs-container.id]
  }
}