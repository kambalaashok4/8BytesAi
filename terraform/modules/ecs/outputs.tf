output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "Name of the ECS Fargate service"
  value       = aws_ecs_service.app.name
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app.name
}

output "autoscaling_min_capacity" {
  description = "Minimum number of ECS tasks (autoscaling lower bound)"
  value       = aws_appautoscaling_target.ecs.min_capacity
}

output "autoscaling_max_capacity" {
  description = "Maximum number of ECS tasks (autoscaling upper bound)"
  value       = aws_appautoscaling_target.ecs.max_capacity
}
