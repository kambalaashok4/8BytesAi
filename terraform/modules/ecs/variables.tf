variable "project_name" {
  description = "Prefix used for all resource names"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "container_image" {
  description = "Docker image to run in the ECS task"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "desired_count" {
  description = "Number of ECS task replicas to run"
  type        = number
}

variable "cpu" {
  description = "vCPU units for the Fargate task"
  type        = number
}

variable "memory" {
  description = "Memory (MiB) for the Fargate task"
  type        = number
}

variable "log_retention_days" {
  description = "CloudWatch log group retention period in days"
  type        = number
}

variable "task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task IAM role"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "ecs_tasks_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of ECS tasks when autoscaling"
  type        = number
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of ECS tasks when autoscaling"
  type        = number
}

variable "autoscaling_cpu_target" {
  description = "Target average CPU utilization (%) that triggers scaling"
  type        = number
}

variable "ebs_volume_size_gib" {
  description = "Size (GiB) of the EBS volume attached to each ECS task"
  type        = number
}

variable "ebs_volume_type" {
  description = "EBS volume type"
  type        = string
}

variable "ebs_mount_path" {
  description = "Container path where the EBS volume is mounted"
  type        = string
}
