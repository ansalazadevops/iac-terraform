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

# Security Group
output "aws_security_group" {
  value = [
    aws_security_group.zabbix_sg.id,
    aws_security_group.zabbix_sg.name,
    aws_security_group.zabbix_sg.ingress[0].from_port,
    aws_security_group.zabbix_sg.ingress[0].to_port,
    aws_security_group.zabbix_sg.ingress[0].protocol,
    aws_security_group.zabbix_sg.ingress[1].from_port,
    aws_security_group.zabbix_sg.ingress[1].to_port,
    aws_security_group.zabbix_sg.ingress[1].protocol,
    aws_security_group.zabbix_sg.egress.cidr_blocks
  ]
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
