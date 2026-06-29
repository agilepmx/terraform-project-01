output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "The IPv4 CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_ipv6_cidr" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.this.ipv6_cidr_block
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "subnet_ids" {
  description = "Map of subnet name to subnet ID"
  value       = { for k, v in aws_subnet.this : k => v.id }
}

output "public_subnet_ids" {
  description = "Map of public subnet name to subnet ID"
  value       = { for k, v in aws_subnet.this : k => v.id if var.subnets_data[k].public == true }
}

output "private_subnet_ids" {
  description = "Map of private subnet name to subnet ID"
  value       = { for k, v in aws_subnet.this : k => v.id if var.subnets_data[k].public == false }
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public-rt.id
}
