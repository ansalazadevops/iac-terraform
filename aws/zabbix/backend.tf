terraform {
  backend "s3" {
    bucket        = "ansalaza-tf-state"
    key           = "aws/zabbix/terraform.tfstate"
    region        = "us-east-1"
    encrypt       = true
    use_lockfile  = true
  }
}
