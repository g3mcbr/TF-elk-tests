# elk/jaars/loadbalancers/main.tf

provider "aws" {
    region = "${var.AWS_REGION}"
}

data "terraform_remote_state" "newvpc" {
  backend = "s3"

  config {
    bucket = "${var.vpc_remote_state_bucket}"
    key    = "${var.vpc_remote_state_key}"
    region = "${var.AWS_REGION}"
  }
}

#module "external_nlb" {
#  source                    = "../modules/services/external_nlb"
#  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
#  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
#  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
#  public_subnet_ids         = "${data.terraform_remote_state.newvpc.public_subnet_ids}"
#}

module "internal_nlb" {
  source                    = "../modules/services/internal_nlb"
  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
  private_subnet_ids         = "${data.terraform_remote_state.newvpc.private_subnet_ids}"
}

terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/loadbalancers/terraform.tfstate"
    region = "us-east-1"
  }
}
