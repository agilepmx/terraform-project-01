variable "subnets_data" {
  type = map(object({
    public = bool
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