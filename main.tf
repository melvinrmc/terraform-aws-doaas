terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "doaas-public-server" {
  ami             = "ami-06c68f701d8090592"
  instance_type   = "t2.micro"
  key_name        = "aws-joe-key"
  security_groups = [aws_security_group.doaas-allow_public_ssh.id]

  subnet_id = aws_subnet.doaas-subnet-0.id

  tags = {
    Name = "doaas-public-server"
  }
}

resource "aws_instance" "doaas-private-server" {
  ami           = "ami-06c68f701d8090592"
  instance_type = "t2.micro"

  key_name = "aws-joe-key"

  security_groups = [aws_security_group.doaas-allow_ssh.id]

  subnet_id = aws_subnet.doaas-subnet-1.id

  tags = {
    Name = "doaas-private-server"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-06c68f701d8090592"
  instance_type = "t2.micro"

  tags = {
    Name = "doaas-instance"
  }
}

resource "aws_ec2_instance_state" "app_server_status" {
  instance_id = aws_instance.app_server.id
  state       = "stopped"
}
