variable "subnets_data" {
  type = map(object({
    public_subnet = bool
    cidr        = string
    az          = string
    ipv6_offset = string
  }))
}
variable "project_name" {
  type = string
}
variable "environment" {
  type = string
} 
variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

module "dev_infra" {
  source = "../../modules/vpc_network"
  project_name = var.project_name
  environment = var.environment
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  subnets_data = var.subnets_data
  }