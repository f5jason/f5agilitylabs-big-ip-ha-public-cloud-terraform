## Create the TGW
resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transit Gateway for routing between hub and app VPCs"
  tags = {
    Name = "${var.prefix}_hub_app_tgw"
  }
}


## Create the TGW Attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "hub-vpc" {
  subnet_ids         = [aws_subnet.hub_bigip1_internal.id, aws_subnet.hub_bigip2_internal.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.hub-vpc.id
  #appliance_mode_support = "enable"
  tags = {
    Name = "${var.prefix}_hub-vpc_tgw_attach"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "app-vpc" {
  subnet_ids         = [aws_subnet.appsvr1.id, aws_subnet.appsvr2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.app-vpc.id
  #appliance_mode_support = "enable"
  tags = {
    Name = "${var.prefix}_app-vpc_tgw_attach"
  }
}

## Create the TGW Route Table
resource "aws_ec2_transit_gateway_route_table" "tgw-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.prefix}-rt_tgw"
  }
}

## Set default route pointing to the hub VPC 
resource "aws_ec2_transit_gateway_route" "tgw_default_via_hub" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}
