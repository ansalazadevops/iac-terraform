# -------------------------------------
# Project variables
# -------------------------------------
variable "environment" {
  default = "Development"
  type = string
}

variable "owner" {
  default = "Antonio Salazar"
  type = string
}

variable "project" {
  default = "zabbix-project"
  type = string
}

variable "region" {
  default     = "us-east-1"
  description = "VPC default Region"
  type        = string
}

# -------------------------------------
# Networking Variables
# -------------------------------------
variable "vpc-cidr" {
    default     = "10.0.0.0/16"
    description = "VPC CIDR Block"
    type        = string 
}

variable "availability-zone-1" {
    default     = "us-east-1a"
    description = "Availability Zone 1"
    type        = string 
}

variable "availability-zone-2" {
    default     = "us-east-1b"
    description = "Availability Zone 2"
    type        = string 
}

variable "availability-zone-3" {
    default     = "us-east-1c"
    description = "Availability Zone 3"
    type        = string 
}

variable "availability-zone-4" {
    default     = "us-east-1d"
    description = "Availability Zone 4"
    type        = string 
}

variable "availability-zone-5" {
    default     = "us-east-1e"
    description = "Availability Zone 5"
    type        = string 
}

variable "availability-zone-6" {
    default     = "us-east-1f"
    description = "Availability Zone 6"
    type        = string 
}

variable "public-subnet-1-cidr" {
    default     = "10.0.1.0/24"
    description = "Public Subnet 1 CIDR Block"
    type        = string 
}

variable "public-subnet-2-cidr" {
    default     = "10.0.2.0/24"
    description = "Public Subnet 1 CIDR Block"
    type        = string 
}

variable "public-subnet-3-cidr" {
    default     = "10.0.3.0/24"
    description = "Public Subnet 3 CIDR Block"
    type        = string 
}

variable "public-subnet-4-cidr" {
    default     = "10.0.4.0/24"
    description = "Public Subnet 4 CIDR Block"
    type        = string 
}

# -------------------------------------
# EC2 Instance Variables
# -------------------------------------
# EC2 Instance Type
variable "ami-micro" {
  default     = "ami-052efd3df9dad4825" # jammy-22.04-amd64-server-20220609
  description = "AWS Ubuntu 22.04 Image"
  type        = string
}

variable "ami-medium" {
  default     = "ami-00874d747dde814fa" # jammy-22.04-amd64-server-20220609
  description = "AWS Ubuntu 22.04 Image"
  type        = string
}

variable "instance-type-micro" {
  default     = "t2.micro"
  description = "AWS T2 Micro EC2 Instance"
  type        = string
}

variable "instance-type-medium" {
  default     = "t2.medium"
  description = "AWS T2 Medium EC2 Instance"
  type        = string
}

variable "ec2-instance-name" {
  default     = "zabbix-ec2-instance"
  description = "AWS EC2 Instance Name"
  type        = string
}

# username for the EC2 instance
variable "host-username" {
  default     = "ubuntu"
  description = "AWS EC2 host username"
  type        = string
}

# SSH variables
variable "ssh-location" {
    default     = "0.0.0.0/0"
    description = "IP Address Tha Can SSH Into the EC2 Instance"
    type        = string 
}

variable "key-pair" {
  default     = "ec2-key"
  description = "ssh key pair name"
  type        = string
}

variable "key-file" {
  default     = "ec2-key.pem"
  description = "pem filename"
  type        = string
}
