### Placeholder ###
#
# Note: This example is incomplete and may not necessarily be correct.
#

# BIG-IP HA via LB (AWS NLB)

resource "aws_lb" "bigip_ha" {
  name               = "bigip-ha-via-lb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.f5_external.id]
  subnets            = [aws_subnet.hub_bigip1_external.id, aws_subnet.hub_bigip2_external.id]

  enable_cross_zone_load_balancing = true

  subnet_mapping {
    subnet_id = aws_subnet.hub_bigip1_external.id
    #allocation_id = ???
  }

  subnet_mapping {
    subnet_id = aws_subnet.hub_bigip1_external.id
    #allocation_id = ???
  }

  tags = {
    Name  = format("%s_bigip_ha_lb", var.prefix)
    Owner = emailid
  }
}

resource "aws_lb_listener" "bigip_ha" {
  load_balancer_arn = aws_lb.bigip_ha.arn
  protocol          = "TCP"
  port              = "443"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bigip_ha.arn
  }
}

resource "aws_lb_target_group" "bigip_ha" {
  vpc_id   = aws_vpc.hub-vpc.id
  protocol = "TCP"
  port     = 443

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
    port                = 443
  }

  stickiness {
    type = "source_ip"
  }
}


resource "aws_lb_target_group_attachment" "bigip1_ha" {
  target_group_arn = aws_lb_target_group.bigip_ha.arn
  target_id        = aws_instance.bigip1.id
  port             = 443
}

resource "aws_lb_target_group_attachment" "bigip2_ha" {
  target_group_arn = aws_lb_target_group.bigip_ha.arn
  target_id        = aws_instance.bigip2.id
  port             = 443
}


resource "aws_security_group" "bigip_ha_lb" {
  name   = format("%s_bigip_ha_lb_sg", var.prefix)
  vpc_id = aws_vpc.hub-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", data.http.myip.response_body)]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", data.http.myip.response_body)]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name  = format("%s_bigip_ha_lb_sg", var.prefix)
    Owner = emailid
  }
}

output "nlb_dns_name" {
  value = aws_lb.bigip_ha.dnsa_name
}
