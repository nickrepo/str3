data "aws_lb_target_group" "LB_tg" {
  name = "ECSTG-dev"
}

data "aws_subnet" "stratsub1" {
  # Specify the filters to find the subnet you're interested in
  filter {
    name   = "tag:Name"
    values = ["public_subnet_1"]  # Update with the name of your subnet
  }
}

data "aws_subnet" "stratsub2" {
  # Specify the filters to find the subnet you're interested in
  filter {
    name   = "tag:Name"
    values = ["public_subnet_0"]  # Update with the name of your subnet
  }
}

data "aws_security_group" "ecs-container" {
  name = "ecs-container"  # Replace this with the name of your security group
}