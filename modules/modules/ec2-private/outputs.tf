output "backend_private_ips" {
  value = aws_instance.backend[*].private_ip
}

output "backend_instance_ids" {
  value = aws_instance.backend[*].id
}
