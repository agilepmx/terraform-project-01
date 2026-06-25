resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  instance_tenancy = "default"

tags = {
    "Name" = var.vpc_name
}
}
resource "aws_internet_gateway" "this" {
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
  
  tags = {
    Name = each.key
  }
}