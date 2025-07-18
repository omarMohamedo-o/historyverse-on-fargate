variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {}
variable "private_key_path" {}
variable "app_local_path" {}
variable "bastion_ip" {}
