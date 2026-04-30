variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Prefix used for all resource names.)."
  type        = string
  default     = "ecs-cw-demo"
}

variable "container_image" {
  description = "Docker image to run in the ECS task"
  type        = string
  default     = "cicd:latest"
  #"nginx:latest"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 3000
}

variable "desired_count" {
  description = "Number of ECS task replicas to run"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "vCPU units for the Fargate task (512 = 0.5 vCPU)"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory (MiB) for the Fargate task"
  type        = number
  default     = 1024
}

variable "log_retention_days" {
  description = "CloudWatch log group retention period in days"
  type        = number
  default     = 7
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of ECS tasks when autoscaling"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of ECS tasks when autoscaling"
  type        = number
  default     = 4
}

variable "autoscaling_cpu_target" {
  description = "Target average CPU utilization (%) that triggers scaling"
  type        = number
  default     = 60
}

variable "ebs_volume_size_gib" {
  description = "Size (GiB) of the EBS volume attached to each ECS task"
  type        = number
  default     = 20
}

variable "ebs_volume_type" {
  description = "EBS volume type (gp3 recommended for Fargate)"
  type        = string
  default     = "gp3"
}

variable "hosted_zone_name" {
  description = "Domain name for the Route 53 hosted zone"
  type        = string
}

variable "ebs_mount_path" {
  description = "Container path where the EBS volume is mounted"
  type        = string
  default     = "/data"
}
