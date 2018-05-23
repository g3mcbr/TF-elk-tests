# elk/050418/cluster/main.tf

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

data "terraform_remote_state" "newvol" {
  backend = "s3"

  config {
    bucket = "${var.vol_remote_state_bucket}"
    key    = "${var.vol_remote_state_key}"
    region = "${var.AWS_REGION}"
  }
}


module "cluster_es" {
  source                    = "../modules/services/cluster_es"
  instance_type             = "${var.instance_type}"
  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
  cluster_name              = "${var.es_cluster_name}"
  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
  vpc_default_sg_id         = "${data.terraform_remote_state.newvpc.vpc_default_sg_id}"
  aws_zones                 = "${data.terraform_remote_state.newvpc.aws_zones}"
  public_subnet_ids         = "${data.terraform_remote_state.newvpc.public_subnet_ids}"
  private_subnet_ids        = "${data.terraform_remote_state.newvpc.private_subnet_ids}"
  vol_id                    = "${data.terraform_remote_state.newvol.vol_id}"
}

module "cluster_lk" {
  source                    = "../modules/services/cluster_lk"
  instance_type             = "${var.instance_type}"
  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
  cluster_name              = "${var.lk_cluster_name}"
  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
  vpc_default_sg_id         = "${data.terraform_remote_state.newvpc.vpc_default_sg_id}"
  aws_zones                 = "${data.terraform_remote_state.newvpc.aws_zones}"
  private_subnet_ids        = "${data.terraform_remote_state.newvpc.private_subnet_ids}"
}

#module "external_nlb" {
#  source                    = "../modules/services/external_nlb"
#  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
#  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
#  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
#  public_subnet_ids         = "${data.terraform_remote_state.newvpc.public_subnet_ids}"
#}

#module "internal_nlb" {
#  source                    = "../modules/services/internal_nlb"
#  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
#  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
#  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
#  private_subnet_ids         = "${data.terraform_remote_state.newvpc.private_subnet_ids}"
#}

module "external_elb" {
  source                    = "../modules/services/external_elb"
  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
  aws_zones                 = "${data.terraform_remote_state.newvpc.aws_zones}"
  vpc_default_sg_id         = "${data.terraform_remote_state.newvpc.vpc_default_sg_id}"
  public_subnet_ids         = "${data.terraform_remote_state.newvpc.public_subnet_ids}"
}

module "internal_elb" {
  source                    = "../modules/services/internal_elb"
  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
  vpc_default_sg_id         = "${data.terraform_remote_state.newvpc.vpc_default_sg_id}"
  private_subnet_ids        = "${data.terraform_remote_state.newvpc.private_subnet_ids}"
}


terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/cluster/terraform.tfstate"
    region = "us-east-1"
  }
}
