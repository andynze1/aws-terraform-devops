// CREATE VPC
resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_blocks[terraform.workspace]
  tags = {
    Name = "${terraform.workspace}-project-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.public_subnet_cidr[terraform.workspace]
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
#  availability_zone = local.availability_zones[terraform.workspace][0]
  tags = {
    Name = "${terraform.workspace}-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.private_subnet_cidr[terraform.workspace]
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"
#  availability_zone       = local.availability_zones[terraform.workspace][1]
  tags = {
    Name = "${terraform.workspace}-private-subnet"
  }
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.vpc.id
  name = "${terraform.workspace}security-group"
  dynamic "ingress" {
    for_each = local.security_group_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-security-group"
  }
}

resource "aws_eip" "public_ip" {
  domain = "vpc"
  network_interface = aws_network_interface.public.id
  
  tags = {
    Name =  "${terraform.workspace}-Public-IP"
  }
}

# Nerwork Interface
resource "aws_network_interface" "public" {
  subnet_id       = aws_subnet.public_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.main.id]

  tags = {
    Name = "${terraform.workspace}-public-interface"
  }
  depends_on = [aws_subnet.public_subnet] 
}


// Create Internet Gateway for VPC
resource "aws_internet_gateway" "internet_gate_way" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${terraform.workspace}-internet-gate-way"
  }
}

// Create Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gate_way.id
  }
  tags = {
    Name = "${terraform.workspace}-public-route-table"
  }
}

// Create Public Route Table (optional, depending on requirements)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  # No internet access required

  tags = {
    Name = "${terraform.workspace}-private-route-table"
  }
}

// Associate Public subnets with Public route table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

// Associate Private subnets with Public route table
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}