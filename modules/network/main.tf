#############################################################################################
# create VPC
#############################################################################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dp-${var.environment}-vpc"
    Env  = var.environment
  }
}

#############################################################################################
# create internet gatway to provide internet access to VPC
#############################################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dp-${var.environment}-igw"
  }
}

#############################################################################################
# create public subnet. it will be attached to igw so resources inside this could be 
# accessible from pulic internet
#############################################################################################
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dp-${var.environment}-public"
  }
}

#############################################################################################
# create two private subnet. it will be attached to NAT gatway so resources inside this could  
# be safe and private but can interact with interner igw when they required to get updates.
# No public access.
#############################################################################################
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "dp-${var.environment}-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "dp-${var.environment}-private-b"
  }
}

#############################################################################################
# Register EIP, is a static IP address  
#############################################################################################
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

#############################################################################################
# create NAT gatway and attach EIP, provide cmmunication between private and public resources
#############################################################################################
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "dp-${var.environment}-nat"
  }
}

#############################################################################################
# create public route table 
#############################################################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

#############################################################################################
# register public route table with igw
#############################################################################################
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

#############################################################################################
# create private route table
#############################################################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

#############################################################################################
# register private route table with NAT gateway
#############################################################################################
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.nat.id
  destination_cidr_block = "0.0.0.0/0"
}

#############################################################################################
# associate public subnet to public route table
#############################################################################################
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#############################################################################################
# associate private subnets to private route table
#############################################################################################
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

#############################################################################################
# create security group to make firewall to secure the resources in vpc
#############################################################################################
resource "aws_security_group" "databricks_sg" {
  name   = "dp-${var.environment}-databricks-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
