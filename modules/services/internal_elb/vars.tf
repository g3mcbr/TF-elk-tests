variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

#variable "vpc_id" {
#  type = "string"
#}

#variable "aws_zones" {
#  type = "list"
#}

#variable "public_subnet_ids" {
#  type = "list"
#}

variable "private_subnet_ids" {
  type = "list"
}

variable "vpc_default_sg_id" {
  type = "string"
}
