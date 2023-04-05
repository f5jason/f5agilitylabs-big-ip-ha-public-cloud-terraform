# Application VPC
resource "aws_vpc" "app-vpc" {
  cidr_block           = var.vpc_cidrs["app"]["vpc"]
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name  = "${var.prefix}-app-vpc"
    Owner = var.emailid
  }
}

# AZ 1 - Subnets
resource "aws_subnet" "appsvr1" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = var.vpc_cidrs["app"]["appsvr1"]
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name  = "${var.prefix}-app-az1"
    Owner = var.emailid
  }
}

# AZ 2 - Subnets
resource "aws_subnet" "appsvr2" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = var.vpc_cidrs["app"]["appsvr2"]
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}b"

  tags = {
    Name  = "${var.prefix}-app-az2"
    Owner = var.emailid
  }
}

# Route Table
resource "aws_route_table" "app_default_tgw" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name  = "${var.prefix}-app-default-tgw-rt"
    Owner = var.emailid
  }
}

resource "aws_main_route_table_association" "app" {
  vpc_id         = aws_vpc.app-vpc.id
  route_table_id = aws_route_table.app_default_tgw.id
}
