# Create Key Pair
# resource "aws_key_pair" "key-pair" {
#  key_name   = "${var.key-pair}"
#  public_key = tls_private_key.ssh_key.public_key_openssh
# }

# Choose RSA algorithm for the private key 
# resource "tls_private_key" "ssh_key" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
# }

# Choose ED25519 algorithm for the private key 
resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

# Upload the public key to AWS EC2
resource "aws_key_pair" "deployer" {
  key_name   = "${var.key-pair}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save the private key to your local directory (Restricted Permissions)
resource "local_sensitive_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key
  filename = "${var.key-path}/${var.key-file}"

  # Change pem file permissions to read/only
  # provisioner "local-exec" {
  #  command = "chmod 0400 ${var.key-file}"
  # }
}

# Output the path to easily locate the key
output "private_key_path" {
  value       = local_sensitive_file.private_key.filename
  description = "Path to your local private key file"
}
