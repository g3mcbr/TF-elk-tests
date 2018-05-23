variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "aws_zones" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "vpc_default_sg_id" {
  type = "string"
}

#variable "PATH_TO_PUBLIC_KEY" {
#  default = "elktestkey.pub"
#}

variable "vol_id" {
  type = "list"
}

variable "cluster_name" {
  type = "string"
}

#variable "vpc_remote_state_bucket" {
#  type = "string"
#}

#variable "vpc_remote_state_key" {
#  type = "string"
#}

variable "instance_type" {
  type = "string"
  default = "t2.micro"
}

#variable "vol_remote_state_bucket" {
#  type = "string"
#}

#variable "vol_remote_state_key" {
#  type = "string"
#}
