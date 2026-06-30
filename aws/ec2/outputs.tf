# VPC
output "aws_vpc" {
  value = aws_vpc.vpc.id
}

# IGW
output "aws_internet_gateway" {
  value = aws_internet_gateway.internet-gateway.id
}

# Subnet
output "aws_subnet" {
  value = aws_subnet.public-subnet-1.id
}

# Route table
output "aws_route_table" {
  value = aws_route_table.public-route-table.id
}

# Route table association
output "aws_route_table_association" {
  value = aws_route_table_association.public-subnet-1-route-table-association.id
}

# ec2 instance public ip
output "aws_instance" {
  value = aws_instance.app-instance-1.public_ip
}
