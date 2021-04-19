terraform {
  backend "s3" {
    bucket = "terraform-tfstate-israel"
    key = "terraform.tfstate"
    region = "eu-central-1"
  }
}