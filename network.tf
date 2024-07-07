resource "aws_vpc" "doaas-vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "doaas-vpc"
  }
}

resource "aws_subnet" "doaas-subnet-0" {
  vpc_id     = aws_vpc.doaas-vpc.id
  cidr_block = "10.1.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "doaas-subnet-0"
  }
}

resource "aws_subnet" "doaas-subnet-1" {
  vpc_id     = aws_vpc.doaas-vpc.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "doaas-subnet-1"
  }
}

resource "aws_internet_gateway" "doaas-igw" {
  vpc_id = aws_vpc.doaas-vpc.id

  tags = {
    Name = "doaas-igw"
  }
}

resource "aws_route_table" "doaas-public-route-table" {
  vpc_id = aws_vpc.doaas-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.doaas-igw.id
  }

  tags = {
    Name = "doaas-public-route-table"
  }
}

resource "aws_route_table_association" "dooas-public-subnet-public-route-association" {
  subnet_id      = aws_subnet.doaas-subnet-0.id
  route_table_id = aws_route_table.doaas-public-route-table.id
}