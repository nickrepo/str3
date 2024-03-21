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
  family = "Strat7"
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
  name            = "Strat7"
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
    subnets          = [data.aws_subnet.stratsub1.id, data.aws_subnet.stratsub2.id]
    assign_public_ip = true
    security_groups  = [data.aws_security_group.ecs-container.id]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.STR_ECS_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}