variable "project_name" {
  type        = string
  description = "Project name identifier."
  default     = "historyverse"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, prod)."
  default     = "production"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ALB and Target Group reside."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ALB placement across multiple AZs."
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID governing ingress to the ALB."
}

variable "container_port" {
  type        = number
  description = "Port the target container listens on (FastAPI: 8000)."
  default     = 8000
}

variable "health_check_path" {
  type        = string
  description = "Application health check path."
  default     = "/health/live"
}

variable "certificate_arn" {
  type        = string
  description = "Optional ACM SSL/TLS certificate ARN for port 443 HTTPS listener."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
