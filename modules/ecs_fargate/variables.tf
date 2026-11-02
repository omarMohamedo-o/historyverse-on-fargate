variable "project_name" {
  type        = string
  description = "Project identifier."
  default     = "historyverse"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, prod)."
  default     = "production"
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster."
  default     = "historyverse-cluster"
}

variable "container_name" {
  type        = string
  description = "Name of the container inside the task definition."
  default     = "historyverse"
}

variable "container_image" {
  type        = string
  description = "Docker image URI (from Docker Hub or AWS ECR)."
  default     = "0marmohamed/historyverse_chatbot:latest"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the container (FastAPI: 8000)."
  default     = 8000
}

variable "cpu" {
  type        = number
  description = "CPU units for Fargate task (256, 512, 1024, 2048, 4096)."
  default     = 512
}

variable "memory" {
  type        = number
  description = "Memory in MiB for Fargate task (512, 1024, 2048, 4096, 8192)."
  default     = 1024
}

variable "desired_count" {
  type        = number
  description = "Desired number of running task replicas."
  default     = 2
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of tasks for autoscaling."
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of tasks for autoscaling."
  default     = 6
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable target-tracking autoscaling based on CPU and memory."
  default     = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs where ECS tasks will be launched."
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to the ECS tasks."
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB target group."
}

variable "execution_role_arn" {
  type        = string
  description = "IAM role ARN for task execution (pull image, write logs, get secrets)."
}

variable "task_role_arn" {
  type        = string
  description = "IAM role ARN for runtime task permissions."
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign a public IP to tasks (false if using private subnets + NAT Gateway)."
  default     = false
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention in days."
  default     = 14
}

variable "environment_variables" {
  type        = list(map(string))
  description = "List of environment variables [{ name = \"FOO\", value = \"BAR\" }]."
  default     = []
}

variable "secrets" {
  type        = list(map(string))
  description = "List of secrets from SSM or Secrets Manager [{ name = \"KEY\", valueFrom = \"arn:...\" }]."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
