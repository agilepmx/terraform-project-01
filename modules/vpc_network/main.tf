locals {
  base_name = "${var.project_name}-${var.environment}-${var.vpc_name}"
  tags = {
    Environment = var.environment
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  instance_tenancy = "default"

tags = merge(
    local.tags,
    {
      Name = local.base_name
    }
  )
}
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

  tags = merge(
    local.tags,
    {
      Name = "${local.base_name}-igw"
    }
  )
}

resource "aws_subnet" "this" {
  for_each = var.subnets_data
  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, parseint(each.value.ipv6_offset,16))}"
  assign_ipv6_address_on_creation = true
  #map_public_ip_on_launch = each.value.public == true ? true : false

  tags = merge(
    local.tags,
    {
      Name = "${local.base_name}-${each.key}"
    }
  )
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.tags,
    {
      Name = "${local.base_name}-public-rt"
    }
  )
}
resource "aws_route" "public_route_ipv4" {
  route_table_id = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
  depends_on = [aws_internet_gateway.this]
}
resource "aws_route" "public_route_ipv6" {
  route_table_id = aws_route_table.public-rt.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id = aws_internet_gateway.this.id
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table_association" "public_subnets_association" {
  for_each = {
  for k, v in var.subnets_data : k => v
  if v.public == true
}
  subnet_id = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public-rt.id
}
