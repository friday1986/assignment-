provider "aws" {
  version = "~> 3.0"
  region  = "us-east-2"
}

# Create a VPC
resource "aws_vpc" "terraform_vp" {
  cidr_block = "192.168.0.0/16"
    tags = {
    Name = "vpcterraform"
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id     = aws_vpc.terraform_vp.id
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "private_sub"
  }
}

resource "aws_subnet" "public_sub" {
  vpc_id     = aws_vpc.terraform_vp.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "public_sub"
  }
}

resource "aws_internet_gateway" "gate_1" {
  vpc_id = aws_vpc.terraform_vp.id

  tags = {
    Name = "gate_1"
  }
}

resource "aws_route_table" "for_internet" {
  vpc_id = aws_vpc.terraform_vp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gate_1.id
  }

  tags = {
    Name = "net_1"
  }
}

resource "aws_route_table_association" "route_1" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.for_internet.id
}

resource "aws_route_table_association" "route_2" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.for_internet.id
}
