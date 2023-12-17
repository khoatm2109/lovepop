# Define ECS cluster
resource "aws_ecs_cluster" "lovepop_ecs_cluster" {
  name = "lovepop-cluster"
}

# Define security group for ECS

resource "aws_security_group" "ecs_security_group" {
  vpc_id = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

# Define ECS task definition
resource "aws_ecs_task_definition" "lovepop_task_definition" {
  family                   = "lovepop-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "lovepop-container",
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

# Define ECS service
resource "aws_ecs_service" "lovepop_service" {
  depends_on = [aws_ecs_task_definition.lovepop_task_definition]
  name            = "lovepop-service"
  desired_count   = 1
  cluster         = aws_ecs_cluster.lovepop_ecs_cluster.id
  task_definition = aws_ecs_task_definition.lovepop_task_definition.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = aws_default_subnet.default[*].id
    security_groups = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }
}