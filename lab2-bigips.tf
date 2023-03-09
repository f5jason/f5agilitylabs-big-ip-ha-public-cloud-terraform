
/*
  aws ec2 describe-images --region us-west-2 --filters Name=name,Values=*BIGIP-16.1.3*25Mbps* | jq '.Images[] |.ImageId, .Name'
*/

data "aws_ami" "f5" {
  most_recent = true

  filter {
    name   = "name"
    values = ["F5 BIGIP-16.1.3.*PAYG-Adv WAF Plus 25Mbps*"]
    # values = ["F5 BIGIP-16.1.2.1-0.0.10 PAYG-Adv WAF Plus 25Mbps-211222202458-3c272b55-0405-4478-a772-d0402ccf13f9"]
    # values = ["*BIGIP-16.0.1.1-0.0.6*3c272b55-0405-4478-a772-d0402ccf13f9*"]
    # values = ["*BIGIP-16.0.1.1-0.0.6*3e567b08-20a9-444f-a72a-7e8da3c2cbdf*"]
    # values = ["*BIGIP-15.1.2.1-0.0.10*3e567b08-20a9-444f-a72a-7e8da3c2cbdf*"]
    # values = ["*BIGIP-15.1.2-0.0.9*3196aead-f3ab-4f8e-b6a1-0955337224c5*"]
    # values = ["*BIGIP-15.1.0.4-0.0.6*3196aead-f3ab-4f8e-b6a1-0955337224c5*"]
    # values = ["*BIGIP-15.1.0.4-0.0.6*3e567b08-20a9-444f-a72a-7e8da3c2cbdf*"]
    # values = ["*BIGIP-15.0.1-0.0.11*3196aead-f3ab-4f8e-b6a1-0955337224c5*"]
    # values = ["*BIGIP-14.1.2.2-0.0.4*3196aead-f3ab-4f8e-b6a1-0955337224c5*"]
  }

  owners = ["aws-marketplace"]
}

# BIGIP 1

resource "aws_instance" "bigip1" {

  ami                    = data.aws_ami.f5.id
  instance_type          = "m5.xlarge"
  key_name               = var.aws_keypair
  subnet_id              = aws_subnet.f5-management-a.id
  vpc_security_group_ids = [aws_security_group.f5_management.id]
  iam_instance_profile   = aws_iam_instance_profile.f5_cloud_failover_profile.name


  tags = {
    Name     = "Big-IP1: BIGIP-Across-Az-Cluster-2nic-PAYG"
    hostname = "bigip1@f5lab.dev"
    owner    = "student@f5lab.dev"
  }
}

resource "aws_network_interface" "bigip1_traffic" {
  subnet_id       = aws_subnet.public-a.id
  private_ips     = var.bigip1_private_ip
  security_groups = [aws_security_group.f5_data.id]

  attachment {
    instance     = aws_instance.bigip1.id
    device_index = 1
  }
}

# BIGIP 2

resource "aws_instance" "bigip2" {

  ami                    = data.aws_ami.f5.id
  instance_type          = "m5.xlarge"
  key_name               = var.aws_keypair
  subnet_id              = aws_subnet.f5-management-b.id
  vpc_security_group_ids = [aws_security_group.f5_management.id]
  iam_instance_profile   = aws_iam_instance_profile.f5_cloud_failover_profile.name


  tags = {
    Name     = "Big-IP2: BIGIP-Across-Az-Cluster-2nic-PAYG"
    hostname = "bigip2@f5lab.dev"
    owner    = "student@f5lab.dev"
  }
}
resource "aws_network_interface" "bigip2_traffic" {
  subnet_id       = aws_subnet.public-b.id
  private_ips     = var.bigip2_private_ip
  security_groups = [aws_security_group.f5_data.id]

  attachment {
    instance     = aws_instance.bigip2.id
    device_index = 1
  }
}

# ELASTIC (PUBLIC) IP ADDRESS ASSIGNMENTS FOR VIRTUAL SERVERS

resource "aws_eip" "bigip1_traffic" {
  vpc                       = true
  network_interface         = aws_network_interface.bigip1_traffic.id
  associate_with_private_ip = var.bigip1_private_ip[0]
}
resource "aws_eip" "bigip2_traffic" {
  vpc                       = true
  network_interface         = aws_network_interface.bigip2_traffic.id
  associate_with_private_ip = var.bigip2_private_ip[0]
}

resource "aws_eip" "virtual_server01" {
  vpc                       = true
  network_interface         = aws_network_interface.bigip1_traffic.id
  associate_with_private_ip = var.bigip1_private_ip[1]
  tags = {
    f5_cloud_failover_label = "example01"
    VIPS                    = "${var.bigip1_private_ip[1]},${var.bigip2_private_ip[1]}"
  }
}

/*
resource "aws_eip" "virtual_server02" {
  vpc                       = true
  network_interface         = aws_network_interface.bigip1_traffic.id
  associate_with_private_ip = var.bigip1_private_ip[2]
}

resource "aws_eip" "virtual_server03" {
  vpc                       = true
  network_interface         = aws_network_interface.bigip1_traffic.id
  associate_with_private_ip = var.bigip1_private_ip[3]
}

resource "aws_eip" "virtual_server04" {
  vpc                       = true
  network_interface         = aws_network_interface.bigip1_traffic.id
  associate_with_private_ip = var.bigip1_private_ip[4]

}
*/
# RENDER TEMPLATE FILE

data "template_file" "postman" {
  depends_on = [null_resource.ecdsa_certs]
  template   = file("./postman_template.json")
  vars = {
    AWS_SECRET_ACCESS_KEY          = var.AWS_SECRET_ACCESS_KEY
    AWS_ACCESS_KEY_ID              = var.AWS_ACCESS_KEY_ID
    AWS_REGION                     = var.aws_region
    BIGIP_ADMIN                    = var.bigip_admin
    BIGIP_ADMIN_PASSWORD           = var.bigip_admin_password
    BIGIP1_MGMT_IP_ADDRESS         = aws_instance.bigip1.public_ip
    BIGIP2_MGMT_IP_ADDRESS         = aws_instance.bigip2.public_ip
    BIGIP1_MGMT_PRIVATE_ADDRESS    = aws_instance.bigip1.private_ip
    BIGIP2_MGMT_PRIVATE_ADDRESS    = aws_instance.bigip2.private_ip
    BIGIP1_TRAFFIC_PRIVATE_ADDRESS = var.bigip1_private_ip[0]
    BIGIP2_TRAFFIC_PRIVATE_ADDRESS = var.bigip2_private_ip[0]
    WEB1_PRIVATE_IP_ADDRESS        = aws_instance.example-a.private_ip
    WEB2_PRIVATE_IP_ADDRESS        = aws_instance.example-b.private_ip
    BIGIP1_DEFAULT_ROUTE           = var.bigip1_default_route
    BIGIP2_DEFAULT_ROUTE           = var.bigip2_default_route
    BIGIP1_EXAMPLE01_ADDRESS       = var.bigip1_private_ip[1]
    BIGIP1_EXAMPLE02_ADDRESS       = var.bigip1_private_ip[2]
    BIGIP1_EXAMPLE03_ADDRESS       = var.bigip1_private_ip[3]
    BIGIP1_EXAMPLE04_ADDRESS       = var.bigip1_private_ip[4]
    BIGIP2_EXAMPLE01_ADDRESS       = var.bigip2_private_ip[1]
    BIGIP2_EXAMPLE02_ADDRESS       = var.bigip2_private_ip[2]
    BIGIP2_EXAMPLE03_ADDRESS       = var.bigip2_private_ip[3]
    BIGIP2_EXAMPLE04_ADDRESS       = var.bigip2_private_ip[4]
    EXAMPLE01A_ECDSA_CERT          = fileexists("example01a.f5lab.dev.cert") ? file("example01a.f5lab.dev.cert") : "null"
    EXAMPLE01A_ECDSA_KEY           = fileexists("example01a.f5lab.dev.key") ? file("example01a.f5lab.dev.key") : "null"
    EXAMPLE01B_ECDSA_CERT          = fileexists("example01b.f5lab.dev.cert") ? file("example01b.f5lab.dev.cert") : "null"
    EXAMPLE01B_ECDSA_KEY           = fileexists("example01b.f5lab.dev.key") ? file("example01b.f5lab.dev.key") : "null"
  }
}


resource "local_file" "postman_rendered" {
  depends_on = [null_resource.ecdsa_certs]
  content    = data.template_file.postman.rendered
  filename   = "postman_rendered.json"
}

resource "aws_s3_bucket" "f5-public-cloud-failover" {
  bucket = "f5-public-cloud-failover-${uuid()}"
  tags = {
    f5_cloud_failover_label = "mydeployment"
  }
  lifecycle {
    ignore_changes = [
      bucket
    ]
  }
}

resource "null_resource" "ecdsa_certs" {
  provisioner "local-exec" {
    command = "create-ecdsa-certs.sh"
  }
}

