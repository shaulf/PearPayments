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
# Create VPC
resource "aws_vpc" "peach_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create the EC2 Instances
resource "aws_instance" "AppServer" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "AppServer"
  }
}

resource "aws_instance" "DBServer" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "MongoDB"
  }
}

resource "aws_instance" "Jenkins" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_instance" "VPN" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "VPNServer"
  }
}
resource "aws_instance" "Grafana" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "Grafana"
  }
}