output "public_alb_dns" {
  description = "The DNS name of the public ALB"
  value       = module.public_alb.alb_dns_name
}

output "backend_private_ips" {
  value = module.ec2_private.backend_private_ips
}
