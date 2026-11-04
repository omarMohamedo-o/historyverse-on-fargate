variable "aws_region" {
  type        = string
  description = "AWS region for infrastructure provisioning."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project identifier for resource naming and tags."
  default     = "historyverse"
}

variable "environment" {
  type        = string
  description = "Target deployment environment (e.g. dev, staging, production)."
  default     = "production"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets (ALB ingress, multi-AZ)."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets (ECS Fargate tasks)."
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT Gateway for private subnets internet access (e.g., outbound LLM APIs)."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use a single NAT Gateway across all AZs to optimize costs in dev/staging."
  default     = true
}

variable "container_image" {
  type        = string
  description = "Docker image URI (from Docker Hub or AWS ECR repository)."
  default     = "ghcr.io/omarmohamedo-o/historyverse-chatbot:latest"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the FastAPI container (8000)."
  default     = 8000
}

variable "cpu" {
  type        = number
  description = "Fargate CPU units (256, 512, 1024, 2048, 4096)."
  default     = 512
}

variable "memory" {
  type        = number
  description = "Fargate memory allocation in MiB (512, 1024, 2048, 4096)."
  default     = 1024
}

variable "desired_count" {
  type        = number
  description = "Number of active Fargate task replicas."
  default     = 2
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of tasks when autoscaling is active."
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of tasks when autoscaling is active."
  default     = 6
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable CPU and Memory target-tracking autoscaling policies."
  default     = true
}

variable "certificate_arn" {
  type        = string
  description = "Optional ACM certificate ARN for enabling HTTPS on the ALB."
  default     = ""
}

variable "environment_variables" {
  type        = list(map(string))
  description = "Additional environment variables passed to the container."
  default     = []
}

variable "secrets" {
  type        = list(map(string))
  description = "Secrets from AWS Systems Manager (SSM) or Secrets Manager."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Custom tags applied to all resources."
  default     = {}
}
