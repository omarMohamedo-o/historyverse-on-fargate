
module "vpc" {
  source = "./modules/vpc"
}

module "ecs_fargate" {
  source        = "./modules/ecs_fargate"
  vpc_id        = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  cluster_name  = "historyverse-cluster"
  container_name = "historyverse"
  container_image = "0marmohamed/historyverse_chatbot:latest"
  container_port = 8501
}

module "alb" {
  source        = "./modules/alb"
  vpc_id        = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  target_group_arn = module.ecs_fargate.target_group_arn
}

module "iam" {
  source = "./modules/iam"
}

output "load_balancer_dns" {
  value = module.alb.lb_dns_name
}
