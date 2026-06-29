output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_network.vpc_id
}