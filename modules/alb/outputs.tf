output "alb_id" {
  description = "ID of the Application Load Balancer."
  value       = aws_lb.this.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer for accessing the API."
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the load balancer (for Route53 alias records)."
  value       = aws_lb.this.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group forwarding traffic to ECS Fargate tasks."
  value       = aws_lb_target_group.this.arn
}
