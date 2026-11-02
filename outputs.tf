output "api_endpoint" {
  description = "The public endpoint URL for HistoryVerse API gateway."
  value       = "http://${module.alb.alb_dns_name}"
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS hostname."
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster identifier."
  value       = module.ecs_fargate.cluster_name
}

output "ecs_service_name" {
  description = "ECS service running the HistoryVerse tasks."
  value       = module.ecs_fargate.service_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group capturing API container stdout/stderr."
  value       = module.ecs_fargate.cloudwatch_log_group_name
}

output "vpc_id" {
  description = "VPC ID where the infrastructure is deployed."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs hosting the ALB."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs hosting the Fargate containers."
  value       = module.vpc.private_subnet_ids
}
