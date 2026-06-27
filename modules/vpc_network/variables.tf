variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
  description = "Name for the VPC (None display name)"
}

variable "subnets_data" {
  type = map(object({
    public_subnet = bool
    cidr = string
    az = string
    ipv6_offset = string 
  }))
  description = "map to use iterate on later to create bulk subnets"
}