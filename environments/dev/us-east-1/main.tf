

module "dev_infra" {
  source = "../../../modules/vpc_network"
  project_name = var.project_name
  environment = var.environment
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  subnets_data = var.subnets_data
  }