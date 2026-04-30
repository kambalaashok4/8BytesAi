output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer — open this in a browser to reach the sample app"
  value       = "http://${module.networking.alb_dns_name}"
}

output "alb_https_url" {
  description = "HTTPS URL of the Application Load Balancer"
  value       = "https://${module.networking.alb_dns_name}"
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster (Container Insights enabled)"
  value       = module.ecs.cluster_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group where container stdout/stderr is sent"
  value       = module.ecs.cloudwatch_log_group_name
}

output "ecs_service_name" {
  description = "Name of the ECS Fargate service"
  value       = module.ecs.service_name
}

output "autoscaling_min_capacity" {
  description = "Minimum number of ECS tasks (autoscaling lower bound)"
  value       = module.ecs.autoscaling_min_capacity
}

output "autoscaling_max_capacity" {
  description = "Maximum number of ECS tasks (autoscaling upper bound)"
  value       = module.ecs.autoscaling_max_capacity
}

output "autoscaling_cpu_target" {
  description = "Target CPU utilization (%) used by the autoscaling policy"
  value       = var.autoscaling_cpu_target
}

output "route53_zone_name" {
  description = "Name of the randomly generated Route 53 hosted zone"
  value       = module.networking.route53_zone_name
}

output "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = module.networking.route53_zone_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM SSL certificate attached to the HTTPS listener"
  value       = module.networking.acm_certificate_arn
}
