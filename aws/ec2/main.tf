# Create VCP
resource "aws_vpc" "vpc" {
    cidr_block           = "${var.vpc-cidr}"
    instance_tenancy     = "default"
    enable_dns_hostnames = true
    
    tags = {
        Name = "cicd-vpc"
    }
}

# Create Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "internet-gateway" {
    vpc_id  = aws_vpc.vpc.id

    tags = {
        Name = "cicd-igw"
    }
}

# Create Public Subnet 1
resource "aws_subnet" "public-subnet-1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "${var.public-subnet-1-cidr}"
    availability_zone       = "${var.availability-zone-1}"
    map_public_ip_on_launch = true

    tags = {
        Name = "cicd-public-subnet-1"
    }    
}

# Create Route Table and add Public Route
resource "aws_route_table" "public-route-table" {
    vpc_id          = aws_vpc.vpc.id

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.internet-gateway.id
    }

    tags = {
        Name = "cicd-public-rtb"
    }
}

# Associate the 'Public Subnet 1' to the 'Public Route Table'
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
    subnet_id       = aws_subnet.public-subnet-1.id
    route_table_id  = aws_route_table.public-route-table.id
}


# Create Security Group for the Application Load Balancer
resource "aws_security_group" "http-security-group" {
  name        = "HTTP Security Group"
  description = "Enable HTTP access on Port 8080"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP Access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "cicd-http-sg"
  }
}

# Create Security Group for SSH connections to the EC2 host 
resource "aws_security_group" "ssh-security-group" {
  name        = "SSH Security Group"
  description = "Enable SSH access on Port 22"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.ssh-location}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "cicd-ssh-sg"
  }
}


# AWS EC2 Instance creation
# App node 1
resource "aws_instance" "cicd-instance-1" {
    ami               = "${var.ami-medium}"
    instance_type     = "${var.instance-type-medium}"

    # Attach Instance to Private Subnet 1
    subnet_id = aws_subnet.public-subnet-1.id

    # Security group
    vpc_security_group_ids = ["${aws_security_group.http-security-group.id}", "${aws_security_group.ssh-security-group.id}"]
    
    key_name          = "${var.key-pair}"

    root_block_device {
        volume_size = 30 
        volume_type = "gp2"
        encrypted   = false
    }

    tags = { 
        "Name" = "${var.ec2-instance-name}" 
    }
}
