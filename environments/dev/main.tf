variable "subnets_data" {
  type = map(object({
    subnet_type = string
    cidr        = string
    az          = string
    ipv6_offset = string
  }))
}
module "dev_infra" {
  source = "../../modules/vpc_network"
  vpc_cidr = "10.16.0.0/16"
  vpc_name = "agilepmx-vpc01"
  subnets_map = var.subnets_data
}