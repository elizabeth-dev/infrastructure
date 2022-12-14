provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "AL2022" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2022-ami-2022.*-arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon Web Services
}

data "aws_subnet" "moon-1" {
  filter {
    name   = "tag:Name"
    values = ["sinope-test-aws-euw1-az3"]
  }
}

data "aws_security_group" "default-sg" {
  vpc_id = data.aws_subnet.moon-1.vpc_id
  name = "default"
}

data "aws_security_group" "http-sg" {
  vpc_id = data.aws_subnet.moon-1.vpc_id
  name = "allow-http"
}

resource "aws_network_interface" "moon-1_0" {
  subnet_id       = data.aws_subnet.moon-1.id
  private_ips     = ["172.31.48.4"]
  ipv6_addresses  = ["2a05:d018:b9c:ec00:818a:a2ef:d4d1:6142"]
  security_groups = [
    data.aws_security_group.default-sg.id,
    data.aws_security_group.http-sg.id
  ]

  tags = {
    Name = "moon-1_0"
  }
}

resource "aws_instance" "moon-1" {
  ami           = data.aws_ami.AL2022.id
  instance_type = "t4g.micro"
  key_name = "me@elizabeth.sh"

  tags = {
    Name = "moon-1"
  }

  network_interface {
    network_interface_id = aws_network_interface.moon-1_0.id
    device_index         = 0
  }

  user_data = data.cloudinit_config.moon-1.rendered
}

resource "aws_eip" "moon-1" {
  vpc      = true
}

resource "aws_eip_association" "moon-1" {
  instance_id   = aws_instance.moon-1.id
  allocation_id = aws_eip.moon-1.id
}

output "moon-1_ip_addr" {
  value = aws_eip.moon-1.public_ip
}

output "moon-1_ipv6_addr" {
  value = "2a05:d018:b9c:ec00:818a:a2ef:d4d1:6142"
}
