variable "vpc_id" {}
variable "public_subnets" {
  type = list(string)
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {}
variable "private_key_path" {}

variable "internal_alb_dns_name" {
  description = "The DNS name of the internal ALB"
  type        = string
}

