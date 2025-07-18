variable "vpc_id" {}
variable "public_subnets" {
  type = list(string)
}
variable "proxy_instance_ids" {
  type = list(string)
}
