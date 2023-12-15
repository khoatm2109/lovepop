
# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm" {
  alarm_name          = "ecs-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm if CPU utilization is greater than or equal to 80% for 2 consecutive periods"
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.sample_service.name
  }

  alarm_actions = [] # Add SNS Topic ARN for alerting
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_alarm" {
  alarm_name          = "ecs-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm if Memory utilization is greater than or equal to 80% for 2 consecutive periods"
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.sample_service.name
  }

  alarm_actions = [] # Add SNS Topic ARN for alerting
}
