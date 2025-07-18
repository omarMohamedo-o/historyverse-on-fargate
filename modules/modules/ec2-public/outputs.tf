output "proxy_ips" {
  value = aws_instance.proxy[*].public_ip
}

output "first_proxy_ip" {
  value = aws_instance.proxy[0].public_ip
}

output "proxy_instance_ids" {
  value = aws_instance.proxy[*].id
}
