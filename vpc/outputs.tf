output "app_name" {
  value = "${var.app_name}"
}

output "app_env" {
  value = "${var.app_env}"
}

output "vpc_id" {
  value = "${module.vpc.id}"
}

output "aws_zones" {
  value = ["${module.vpc.aws_zones}"]
}

output "vpc_default_sg_id" {
  value = "${module.vpc.vpc_default_sg_id}"
}

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnet_ids}"]
}

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnet_ids}"]
}
