# Select BIG-IP AMI to use

data "aws_ami" "bigip" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.f5_ami_search_name]
  }
  owners = ["aws-marketplace"]
}

data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"] # The owner for official Amazon Linux AMIs

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Pattern for Amazon Linux 2 AMI names
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "f5_ami_name" {
  value = data.aws_ami.bigip.name
}

output "f5_ami_id" {
  value = data.aws_ami.bigip.id
}

output "linux_ami_name" {
  value = data.aws_ami.linux.name
}

output "linux_ami_id" {
  value = data.aws_ami.linux.id
}
