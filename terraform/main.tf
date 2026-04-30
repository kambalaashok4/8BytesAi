module "networking" {
  source = "./modules/networking-vpc-alb"

  project_name     = var.project_name
  container_port   = var.container_port
  hosted_zone_name = var.hosted_zone_name
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "ecs" {
  source = "./modules/ecs"

  project_name             = var.project_name
  aws_region               = var.aws_region
  container_image          = var.container_image
  container_port           = var.container_port
  desired_count            = var.desired_count
  cpu                      = 512
  # var.cpu
  memory                   = 1024
  #var.memory
  log_retention_days       = var.log_retention_days
  task_execution_role_arn  = module.iam.task_execution_role_arn
  task_role_arn            = module.iam.task_role_arn
  public_subnet_ids        = module.networking.public_subnet_ids
  ecs_tasks_sg_id          = module.networking.ecs_tasks_sg_id
  target_group_arn         = module.networking.target_group_arn
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity
  autoscaling_cpu_target   = var.autoscaling_cpu_target
  ebs_volume_size_gib      = var.ebs_volume_size_gib
  ebs_volume_type          = var.ebs_volume_type
  ebs_mount_path           = var.ebs_mount_path
}
