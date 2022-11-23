resource "aws_vpc" "mtc_vpc" {
  cidr_block = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  
    tags = {
        name = "dev"
    }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id = aws_vpc.mtc_vpc.id
  cidr_block = "10.123.1.0/24"  
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  
    tags = {
        name = "dev-public"
    }
}

resource "aws_internet_gateway" "mtc_igw" {
  vpc_id = aws_vpc.mtc_vpc.id
  
    tags = {
        name = "dev-igw"
    }
}

resource "aws_route_table" "mtc_public_route_table" {
  vpc_id = aws_vpc.mtc_vpc.id
  
    tags = {
        name = "dev-public_rt"
    }
}

resource "aws_route" "mtc_public_route" {
  route_table_id = aws_route_table.mtc_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.mtc_igw.id
}

resource "aws_route_table_association" "mtc_public_route_table_association" {
  subnet_id = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_route_table.id
}

resource "aws_security_group" "mtc_sg"{
  name = "dev_sg"
  description = "dev security group"
  vpc_id = aws_vpc.mtc_vpc.id 

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "mtc_key" {
  key_name = "dev_key"
  public_key = file("C:/Users/juana/.ssh/mtckey.pub")
}