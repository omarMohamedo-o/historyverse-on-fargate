# ==============================================================================
# HistoryVerse Architecture on AWS ECS Fargate
# Multi-AZ VPC + Public ALB + Private Fargate Service + Strict Security Groups
# ==============================================================================

# 1. Multi-AZ Networking & Subnet Infrastructure
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  tags                 = var.tags
}

# 2. Network Security Boundaries (Zero-Trust Ingress)
module "security" {
  source = "./modules/security"

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
  tags           = var.tags
}

# 3. IAM Roles & Least-Privilege Policies
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

# 4. Public Application Load Balancer
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
  container_port    = var.container_port
  health_check_path = "/health/live"
  certificate_arn   = var.certificate_arn
  tags              = var.tags
}

# 5. ECS Fargate Cluster, Task Definition & Autoscaling Service
module "ecs_fargate" {
  source = "./modules/ecs_fargate"

  project_name          = var.project_name
  environment           = var.environment
  cluster_name          = "${var.project_name}-${var.environment}-cluster"
  container_name        = var.project_name
  container_image       = var.container_image
  container_port        = var.container_port
  cpu                   = var.cpu
  memory                = var.memory
  desired_count         = var.desired_count
  min_capacity          = var.min_capacity
  max_capacity          = var.max_capacity
  enable_autoscaling    = var.enable_autoscaling
  subnet_ids            = module.vpc.private_subnet_ids
  security_group_id     = module.security.ecs_tasks_security_group_id
  target_group_arn      = module.alb.target_group_arn
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  assign_public_ip      = false
  environment_variables = var.environment_variables
  secrets               = var.secrets
  tags                  = var.tags
}
