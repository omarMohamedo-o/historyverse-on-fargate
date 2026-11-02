variable "project_name" {
  type        = string
  description = "Name of the project for resource naming and tagging."
  default     = "historyverse"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, prod)."
  default     = "production"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets (at least 2 for ALB HA across multiple AZs)."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets (for ECS tasks)."
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Provision NAT Gateway for private subnets egress traffic (LLM API calls, package fetches)."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use a single NAT Gateway across all AZs to optimize costs in dev/test."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Additional tags for VPC resources."
  default     = {}
}
