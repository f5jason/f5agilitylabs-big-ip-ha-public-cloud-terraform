# Internet Gateway

resource "aws_internet_gateway" "hub_igw" {
  vpc_id = aws_vpc.hub-vpc.id

  tags = {
    Name  = "${var.prefix}-hub_igw"
    Owner = var.emailid
  }
}
