# live/dev/vpc/main.tf

provider "aws" {
    region = "${var.AWS_REGION}"
}

module "vpc" {
  source    = "github.com/silinternational/terraform-modules//aws/vpc?ref=2.0.2"
  app_name  = "${var.app_name}"
  app_env   = "${var.app_env}"
  aws_zones = "${var.aws_zones}"
}

terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
