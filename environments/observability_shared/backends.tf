terraform {
  backend "s3" {
    bucket  = "tfstate-878024869515"
    key     = "global/remote-state/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}