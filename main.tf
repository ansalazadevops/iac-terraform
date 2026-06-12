#  import mapping
import {
  to = aws_key_pair.my_existing_key
  id = "${var.key-pair}"
}

# 2. Create the target resource shell
resource "aws_key_pair" "my_existing_key" {
  # Leave this temporarily empty or just provide the key_name.
  # Terraform will help generate the rest during the plan step.
  key_name = "${var.key-pair}"
}
