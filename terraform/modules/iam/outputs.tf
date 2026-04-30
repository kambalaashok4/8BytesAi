output "task_execution_role_arn" {
  description = "ARN  ECS task execution IAM role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_arn" {
  description = "ARN  ECS task IAM role"
  value       = aws_iam_role.ecs_task.arn
}
