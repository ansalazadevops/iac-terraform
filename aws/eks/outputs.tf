# -------------------------------------
# Networking Outputs
# -------------------------------------
# VPC
output "aws_vpc" {
  value = aws_vpc.eks_vpc.id
}

# Subnets
output "aws_subnet" {
  value = aws_subnet.public_az1.id
}

output "aws_subnet" {
  value = aws_subnet.public_az2.id
}

# IGW
output "aws_internet_gateway" {
  value = aws_internet_gateway.igw.id
}

# Route table
output "aws_route_table" {
  value = aws_route_table.public_rt.id
}

# Route table association
output "aws_route_table_association" {
  value = aws_route_table_association.rt_association_az1.id
}

output "aws_route_table_association" {
  value = aws_route_table_association.rt_association_az2.id
}

# -------------------------------------
# IAM Roles Outputs
# -------------------------------------
output "aws_iam_role" {
  value = aws_iam_role.eks_cluster_role.name
}

output "aws_iam_role" {
  value = aws_iam_role.eks_node_role.name
}

# -------------------------------------
# EKS Control Plane Outputs
# -------------------------------------
output "eks_cluster" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

