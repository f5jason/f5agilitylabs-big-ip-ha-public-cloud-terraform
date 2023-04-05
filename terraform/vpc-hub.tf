# Hub VPC
resource "aws_vpc" "hub-vpc" {
  cidr_block           = var.vpc_cidrs["hub"]["vpc"]
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name  = "${var.prefix}-hub-vpc"
    Owner = var.emailid
  }
}

# AZ 1 - Subnets
resource "aws_subnet" "hub_bigip1_mgmt" {
  vpc_id                  = aws_vpc.hub-vpc.id
  cidr_block              = var.vpc_cidrs["hub"]["bigip1_mgmt"]
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name  = "hub_bigip1_mgmt"
    Owner = var.emailid
  }
}

resource "aws_subnet" "hub_bigip1_external" {
  vpc_id                  = aws_vpc.hub-vpc.id
  cidr_block              = var.vpc_cidrs["hub"]["bigip1_external"]
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name  = "hub_bigip1_external"
    Owner = var.emailid
  }
}

resource "aws_subnet" "hub_bigip1_internal" {
  vpc_id                  = aws_vpc.hub-vpc.id
  cidr_block              = var.vpc_cidrs["hub"]["bigip1_internal"]
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name  = "hub_bigip1_internal"
    Owner = var.emailid
  }
}

# AZ 2 - Subnets
resource "aws_subnet" "hub_bigip2_mgmt" {
  vpc_id                  = aws_vpc.hub-vpc.id
  cidr_block              = var.vpc_cidrs["hub"]["bigip2_mgmt"]
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}b"

  tags = {
    Name  = "hub_bigip2_mgmt"
    Owner = var.emailid
  }
}

resource "aws_subnet" "hub_bigip2_external" {
  vpc_id                  = aws_vpc.hub-vpc.id
  cidr_block              = var.vpc_cidrs["hub"]["bigip2_external"]
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}b"

  tags = {
    Name  = "hub_bigip2_external"
    Owner = var.emailid
  }
}

resource "aws_subnet" "hub_bigip2_internal" {
  vpc_id                  = aws_vpc.hub-vpc.id
  cidr_block              = var.vpc_cidrs["hub"]["bigip2_internal"]
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}b"

  tags = {
    Name  = "hub_bigip2_internal"
    Owner = var.emailid
  }
}

# Route Table - VPC
resource "aws_route_table" "hub_default" {
  vpc_id = aws_vpc.hub-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hub_igw.id
  }

  route {
    cidr_block         = "10.1.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name                    = "hub-default"
    Owner                   = "${var.emailid}"
    f5_cloud_failover_label = "mydeployment"
  }
}

resource "aws_main_route_table_association" "hub" {
  vpc_id         = aws_vpc.hub-vpc.id
  route_table_id = aws_route_table.hub_default.id
}


# Route Table - Internal subnet
resource "aws_route_table" "hub_internal_ngw" {
  vpc_id = aws_vpc.hub-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hub_ngw.id
  }

  route {
    cidr_block         = "10.1.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}

resource "aws_route_table_association" "hub_internal_ngw_az1" {
  subnet_id      = aws_subnet.hub_bigip1_internal.id
  route_table_id = aws_route_table.hub_internal_ngw.id
}

resource "aws_route_table_association" "hub_internal_ngw_az2" {
  subnet_id      = aws_subnet.hub_bigip2_internal.id
  route_table_id = aws_route_table.hub_internal_ngw.id
}
