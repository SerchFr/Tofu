terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  
  backend "s3" {
    bucket = "my-first-container-aws-campus-numerique-ais-2026"
    key    = "infra/terraform.tfstate"
    region = "eu-west-3"
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "vm_sg" {
  name        = "${var.vm_name}-sg"
  description = "Security group pour ${var.vm_name}"
  vpc_id      = data.aws_vpc.default.id

  # Équivalent du security group "default" d'OpenStack : SSH entrant
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à votre IP en production
  }

  # HTTP entrant (utile si vous installez nginx comme dans le projet Ansible)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Web service port 82"
    from_port   = 82
    to_port     = 82
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Web service port 82"
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Web service port 82"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vm_name}-sg"
  }
}

resource "aws_key_pair" "vm" {
  key_name   = var.keypair_name
  public_key = file(var.ssh_public_key)
}

resource "aws_instance" "vm" {
  ami                    = var.ami_id                           # ami-0e1c4170d9c01184b
  instance_type          = var.instance_type                    # t3.micro
  key_name               = aws_key_pair.vm.key_name 
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.vm_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = var.vm_name
  }
}



