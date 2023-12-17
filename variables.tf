variable "alarm_ecs_running_tasks_threshold" {
  type        = number
  default     = 0
  description = "Alarm when the number of ecs service running tasks is lower than a certain value. CloudWatch Container Insights must be enabled for the cluster."
}

variable "alarm_prefix" {
  type        = string
  description = "String prefix for cloudwatch alarms. (Optional)"
  default     = "alarm"
}
