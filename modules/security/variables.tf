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
  description = "VPC ID where security groups will be created."
}

variable "container_port" {
  type        = number
  description = "Port exposed by the FastAPI container (default 8000)."
  default     = 8000
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
