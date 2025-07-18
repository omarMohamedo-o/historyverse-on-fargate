module "vpc" {
  source = "./modules/vpc"
}

module "ec2_public" {
  source            = "./modules/ec2-public"
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
  key_name          = "mykey"
  private_key_path  = "~/.ssh/mykey"
internal_alb_dns_name = module.internal_alb.alb_dns_name

}

module "ec2_private" {
  source            = "./modules/ec2-private"
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  key_name          = "mykey"
  private_key_path  = "~/.ssh/mykey"
  app_local_path    = "./app"
  bastion_ip        = module.ec2_public.first_proxy_ip
}

module "internal_alb" {
  source              = "./modules/internal-alb"
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  backend_instance_ids = module.ec2_private.backend_instance_ids
}

module "public_alb" {
  source             = "./modules/public-alb"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  proxy_instance_ids = module.ec2_public.proxy_instance_ids
}
