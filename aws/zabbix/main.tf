# ==============================================================================
# 1. NETWORKING 
# ==============================================================================
resource "aws_vpc" "zabbix_vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
}

resource "aws_subnet" "zabbix_subnet" {
  vpc_id                  = aws_vpc.zabbix_vpc.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.zabbix_vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.zabbix_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.zabbix_subnet.id
  route_table_id = aws_route_table.rt.id
}

# ==============================================================================
# 2. Security Group
# ==============================================================================
resource "aws_security_group" "zabbix_sg" {
  name   = "zabbix-traffic"
  vpc_id = aws_vpc.zabbix_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10051
    to_port     = 10051
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==============================================================================
# 3. EC2 Instance
# ==============================================================================
resource "aws_instance" "zabbix" {
  ami           = "${var.ami-micro}"
  instance_type = "${var.instance-type-micro}"
  subnet_id     = aws_subnet.zabbix_subnet.id
  vpc_security_group_ids = [aws_security_group.zabbix_sg.id]
  key_name      = "${var.key-pair}"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              # Launch minimal standalone Zabbix Appliance
              docker run --name zabbix-appliance -p 80:80 -p 10051:10051 -d zabbix/zabbix-appliance:latest
              EOF

  tags = { Name = "Zabbix-Server" }
}
