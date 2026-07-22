# -------------------------------------
# Networking Outputs
# -------------------------------------
# VPC
output "aws_vpc" {
  value = aws_vpc.zabbix_vpc.id
}

# Subnet
output "aws_subnet_ids" {
  value = aws_subnet.zabbix_subnet.id
}

# IGW
output "aws_internet_gateway" {
  value = aws_internet_gateway.igw.id
}

# Route table
output "aws_route_table" {
  value = aws_route_table.rt.id
}

# Route table association
output "aws_route_table_associations" {
  value = aws_route_table_association.rt_association.id
}

# -------------------------------------
# EC2 Instance Outputs
# -------------------------------------
output "aws_instance" {
  value = [ 
    aws_instance.ec2-instance-1.id,
    aws_instance.ec2-instance-1.public_ip
  ]
}
