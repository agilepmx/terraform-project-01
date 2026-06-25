resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  instance_tenancy = "default"

tags = {
    "Name" = var.vpc_name
}
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "all_subnets" {
  for_each = var.subnets_map
  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, parseint(each.value.ipv6_offset,16))}"
  assign_ipv6_address_on_creation = true
  #map_public_ip_on_launch = each.value.subnet_type == "web" ? true : false
  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-web-rt"
  }
}
resource "aws_route" "public_route_ipv4" {
  route_table_id = aws_route_table.web-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route" "public_route_ipv6" {
  route_table_id = aws_route_table.web-rt.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "web_subnets_association" {
  for_each = {
  for k, v in var.subnets_map : k => v
  if v.subnet_type == "web"
}

  subnet_id = aws_subnet.all_subnets[each.key].id
  route_table_id = aws_route_table.web-rt.id
}
