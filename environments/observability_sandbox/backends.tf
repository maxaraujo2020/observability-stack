terraform {
  backend "s3" {
    bucket  = "sandbox-observability-s3-tfstate-300012770768"
    key     = "global/remote-state/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}