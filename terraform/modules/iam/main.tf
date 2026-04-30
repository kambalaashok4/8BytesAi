
# Data

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


# IAM — Task Execution Role

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com","ebs.amazonaws.com","ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project_name}-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = { Name = "${var.project_name}-task-exec-role" }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


data "aws_iam_policy_document" "ecs_task_execution_extra" {
  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:DescribeAvailabilityZones",
      "ec2:CreateVolume",
      "ec2:CreateTags",
      "ec2:DescribeVolumes"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/${var.project_name}:*",
                 "arn:aws:ec2:${data.aws_region.current.name}::volume/*","${aws_iam_role.ecs_task_execution.arn}"]
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_extra" {
  name   = "${var.project_name}-cw-logs"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.ecs_task_execution_extra.json
}


# IAM — Task Role (needed for EBS managed volumes)
resource "aws_iam_role" "ecs_task" {
  name               = "${var.project_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = { Name = "${var.project_name}-task-role" }
}

resource "aws_iam_role_policy_attachment" "ecs_task_ebs" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSInfrastructureRolePolicyForVolumes"
}
