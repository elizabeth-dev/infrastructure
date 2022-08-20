terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.27.0"
    }
  }
}

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

resource "aws_network_interface" "moon-1_0" {
  subnet_id       = data.aws_subnet.moon-1.id
  private_ips     = ["172.31.48.4"]

  tags = {
    Name = "moon-1_0"
  }
}

resource "aws_instance" "moon-1" {
  ami           = data.aws_ami.AL2022.id
  instance_type = "t4g.small"
  key_name = "me@elizabeth.sh"

  tags = {
    Name = "moon-1"
  }

  network_interface {
    network_interface_id = aws_network_interface.moon-1_0.id
    device_index         = 0
  }
}

resource "aws_eip" "moon-1" {
  vpc      = true
}

resource "aws_eip_association" "moon-1" {
  instance_id   = aws_instance.moon-1.id
  allocation_id = aws_eip.moon-1.id
}
