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

variable "secrets_arns" {
  type        = list(string)
  description = "List of Secrets Manager ARNs the execution role is authorized to read."
  default     = ["*"]
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
