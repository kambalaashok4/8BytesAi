# ecs-cloudwatch-ecs-fargate-cicd

Terraform project that provisions an **AWS ECS Fargate** cluster in `us-east-1`
with full **CloudWatch observability**:

- **ECS Fargate** cluster running `nginx:latest` (or any image you choose)  
- **CloudWatch Logs** — container stdout/stderr via the `awslogs` log driver  
- **ECS Container Insights** — CPU, memory, network, and storage metrics in CloudWatch  
- **Application Load Balancer** — reachable HTTP endpoint output after `apply`  
- **VPC** with 2 public subnets across different AZs, Internet Gateway, route tables, and security groups  

---

## Prerequisites

| Tool | Minimum version |
|------|----------------|
| [Terraform](https://developer.hashicorp.com/terraform/downloads) | 1.5+ |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) | v2 |
| AWS credentials with permissions to manage ECS, EC2, IAM, CloudWatch, and ELB resources | — |

Configure your AWS credentials before running Terraform:

```bash
# Option A — environment variables
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-1

# Option B — AWS CLI profile
aws configure --profile my-profile
export AWS_PROFILE=my-profile
```

---

## Deploy

```bash
cd terraform

# 1. Download provider plugins
terraform init

# 2. Preview the changes
terraform plan

# 3. Apply (type "yes" when prompted)
terraform apply
```

After a successful apply, Terraform prints the ALB URL:

```
alb_dns_name        = "http://<alb-hostname>.us-east-1.elb.amazonaws.com"
cloudwatch_log_group = "/ecs/ecs-cw-demo"
ecs_cluster_name    = "ecs-cw-demo-cluster"
ecs_service_name    = "ecs-cw-demo-service"
```

Open the `alb_dns_name` URL in a browser — you should see the **nginx welcome page**.

> **Note:** it may take 1–2 minutes for the ECS tasks to pass health checks and the ALB to start routing traffic.

---

## Customise

Override any variable on the command line:

```bash
terraform apply \
  -var="project_name=my-app" \
  -var="container_image=my-image:latest" \
  -var="desired_count=2" \
  -var="log_retention_days=14"
```

Or create a `terraform/terraform.tfvars` file:

```hcl
project_name    = "my-app"
container_image = "my-image:latest"
desired_count   = 2
```

---

## CloudWatch Logs

Container stdout/stderr is forwarded automatically via the `awslogs` log driver.

**Where to find them:**

1. Open the [AWS Console → CloudWatch → Log groups](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)
2. Select the log group printed in the Terraform output (default: `/ecs/ecs-cw-demo`)
3. Click any log stream (named `ecs/<container>/<task-id>`) to view log events

Or query with the AWS CLI:

```bash
LOG_GROUP=$(terraform -chdir=terraform output -raw cloudwatch_log_group)

aws logs tail "$LOG_GROUP" --follow
```

---

## Container Insights metrics

ECS Container Insights is **enabled on the cluster** so CloudWatch automatically
collects CPU, memory, network I/O, and storage metrics at the cluster, service,
and task level.

**Where to find them:**

1. Open the [AWS Console → CloudWatch → Container Insights](https://console.aws.amazon.com/cloudwatch/home#container-insights:infrastructure)
2. Select **ECS Clusters** in the drop-down
3. Choose the cluster (default: `ecs-cw-demo-cluster`)

You can also view them under **CloudWatch → Metrics → ECS**.

---

## Destroy

```bash
terraform -chdir=terraform destroy
```

Type `yes` when prompted. All AWS resources created by this project will be deleted.



###########GitHub ACTIONS CD/CD#######################