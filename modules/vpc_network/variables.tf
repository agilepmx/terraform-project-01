variable "vpc_cidr" {
  type = string
  description = "CIDR block for the VPC"
}
variable "vpc_name" {
  type = string
  description = "Name for the VPC (None display name)"
}
variable "subnets_map" {
  type = map(object({
    cidr = string
    az = string
    ipv6_offset = string 
  }))
  description = "map to use iterate on later to create bulk subnets"
}