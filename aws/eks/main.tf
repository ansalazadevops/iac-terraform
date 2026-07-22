# ==============================================================================
# 1. NETWORKING (Minimal VPC Setup)
# ==============================================================================
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks-vpc"
  }
}

# Two public subnets in different Availability Zones (Required by EKS)
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  availability_zone       = "${var.availability-zone-1}"
  map_public_ip_on_launch = true

  tags = {
    Name                          = "eks-public-1a"
    "kubernetes.io/cluster/eks"   = "shared"
    "kubernetes.io/role/elb"      = "1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone       = "${var.availability-zone-2}"
  map_public_ip_on_launch = true

  tags = {
    Name                          = "eks-public-1b"
    "kubernetes.io/cluster/eks"   = "shared"
    "kubernetes.io/role/elb"      = "1"
  }
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

# Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_association_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_association_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# ==============================================================================
# 2. IAM ROLES (Required for EKS Cluster & Worker Nodes)
# ==============================================================================
# Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Node Group Role
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_read" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# ==============================================================================
# 3. EKS CONTROL PLANE
# ==============================================================================
resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# ==============================================================================
# 4. CHEAP SPOT MANAGED NODE GROUP
# ==============================================================================
resource "aws_eks_node_group" "spot_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "spot-shared-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]

  # Leverage EC2 Spot Instances for ~70-90% discount
  capacity_type = "SPOT"

  # Diversify instance types to maximize Spot availability
  # (t3.small = 2 vCPU, 2GB RAM; t3a.small = AMD variant)
  instance_types = ["t3.small", "t3a.small", "t2.small"]

  # Disk configuration: Reduce storage footprint to minimal 20GB gp3 disk
  disk_size = 20

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 3
  }

  # Enable graceful upgrades
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_read,
  ]
}
