# Define VPC
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "ecs-vpc"
  }
}

# Define ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "sample-cluster"
}

# Define ECS task definition
resource "aws_ecs_task_definition" "sample_task" {
  family                   = "sample-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "sample-container",
    "image": "nginx:latest",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

# Define IAM role for ECS execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Define ECS service
resource "aws_ecs_service" "sample_service" {
  name            = "sample-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.sample_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = aws_subnet.ecs_subnets[*].id
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  depends_on = [aws_ecs_task_definition.sample_task]
}

# Define subnets for ECS
resource "aws_subnet" "ecs_subnets" {
  count = 2

  cidr_block = "10.0.${count.index + 1}.0/24"
  vpc_id     = aws_vpc.ecs_vpc.id
}

# Define security group for ECS
resource "aws_security_group" "ecs_security_group" {
  vpc_id = aws_vpc.ecs_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
