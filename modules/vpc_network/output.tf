output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = {for k, v in aws_subnet.all_subnets:k=>v.id}
}