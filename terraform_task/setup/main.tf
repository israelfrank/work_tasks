provider "aws" {
  region  = "eu-central-1"
}

resource "aws_vpc" "Vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "Vpc-dev"
  }
}

resource "aws_internet_gateway" "Gw" {
  vpc_id = aws_vpc.Vpc.id

  tags = {
    Name = "Gw-Dev"
  }
}

resource "aws_route_table" "Route" {
vpc_id = aws_vpc.Vpc.id

route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.Gw.id
}
tags = {
Name = "Route-table"
  }
}

resource "aws_subnet" "Subnet" {
  vpc_id     = aws_vpc.Vpc.id
  cidr_block = "192.168.10.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Sub-Dev"
  }
}

resource "aws_route_table_association" "Association" {
  subnet_id      = aws_subnet.Subnet.id
  route_table_id = aws_route_table.Route.id
}

resource "aws_security_group" "Sg-Ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.Vpc.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_ssh"
  }
}

module  "ec2" { 
  source = "../modules/"
  depends_on = [aws_internet_gateway.Gw]
  subnet_id  = aws_subnet.Subnet.id
  vpc_security_group_ids =  [aws_security_group.Sg-Ssh.id]
}

output "Private-ips" {
  value = module.ec2.instance_Private-ips
}

output "Public-ips" {
  value = module.ec2.instance_Public-ips
}