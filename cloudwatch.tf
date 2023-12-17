resource "aws_cloudwatch_metric_alarm" "ecs_running_tasks" {
  count = length(aws_sns_topic.lovepop_sns.arn) > 0 && var.alarm_ecs_running_tasks_threshold > 0 ? 1 : 0

  alarm_name                = "${var.alarm_prefix}-ecs-${aws_ecs_service.lovepop_service.name}-running-tasks"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "RunningTaskCount"
  namespace                 = "ECS/ContainerInsights"
  period                    = "30"
  statistic                 = "Average"
  threshold                 = var.alarm_ecs_running_tasks_threshold
  alarm_description         = "Ecs service running tasks is lower than the threshold"
  alarm_actions             = [aws_sns_topic.lovepop_sns.arn]
  treat_missing_data        = "ignore"

  dimensions = {
    ClusterName = aws_ecs_cluster.lovepop_ecs_cluster.name
    ServiceName = aws_ecs_service.lovepop_service.name
  }
}