locals {
  base_name = "${var.project_name}-${var.environment}-${var.vpc_name}"
  tags = {
    Environment = var.environment
    ManagedBy = "Terraform"
  }

  public_subnets = {
    for k, v in var.subnets_data : k => v
    if v.public == true
  }
  private_subnets = {
    for k, v in var.subnets_data : k => v
    if v.public == false
  }
  az_to_public_subnets = {
    for k, v in var.subnets_data : v.az => k
    if v.public == true
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
  for_each = local.public_subnets
  subnet_id = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_eip" "nat-eip" {
  for_each = local.public_subnets
  domain = "vpc"
  tags = merge(
    local.tags,
    {
      Name = "${local.base_name}-nat-eip-${each.value.az}"
    }
  )
}

resource "aws_nat_gateway" "public-nat-gw" {
  for_each = local.public_subnets
  allocation_id = aws_eip.nat-eip[each.key].id
  subnet_id = aws_subnet.this[each.key].id

  tags = merge(
    local.tags,
    {
      Name = "${local.base_name}-nat-gw-${each.value.az}"
    }
  )
}

resource "aws_route_table" "private-rt" {
  for_each = local.public_subnets
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.tags,
    {
      Name = "${local.base_name}-${each.value.az}-private-rt"
    }
  )
}
resource "aws_route" "private_route" {
  for_each = local.public_subnets
  route_table_id = aws_route_table.private-rt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.public-nat-gw[each.key].id
  depends_on = [aws_nat_gateway.public-nat-gw]
}
resource "aws_route_table_association" "private_subnets_association" {
  for_each = local.private_subnets
  subnet_id = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private-rt[local.az_to_public_subnets[each.value.az]].id
}