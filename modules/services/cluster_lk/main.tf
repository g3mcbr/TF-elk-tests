# jaars/modules/cluster_lk/main.tf

#data "aws_ami" "ecs_ami" {
#  most_recent = true
#  owners      = ["amazon"]
#
#  filter {
#    name   = "name"
#    values = ["amzn-ami-*-amazon-ecs-optimized"]
#  }
#}

data "template_file" "user_data" {
  template = "${file("${path.module}/ecs_user_data.sh")}"
  vars {
  cluster_name = "ecs_${var.app_name}-${var.app_env}-${var.cluster_name}"
  }
}

resource "aws_instance" "ecs_host" {
  count                 = "${length(var.private_subnet_ids)}"
#  ami                   = "${data.aws_ami.ecs_ami.id}"
#  ami                   = "ami-71ef560b"
  ami                   = "ami-a7a242da"
#  ami                   = "ami-aff65ad2"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${element(var.private_subnet_ids, count.index)}"
  security_groups       = ["${var.vpc_default_sg_id}","${aws_security_group.logstash-inbound.id}"]
  iam_instance_profile  = "ecsELKInstanceRole"
  key_name              = "elk-test"
  user_data             = "${data.template_file.user_data.rendered}"

  tags {
    "Name"              = "${var.cluster_name}-docker_ecs_host-${count.index}"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "ecs_${var.app_name}-${var.app_env}-${var.cluster_name}"
}

# security group for elasticsearch inbound access
resource "aws_security_group" "logstash-inbound" {
  vpc_id          = "${var.vpc_id}"
  name            = "${var.app_name}-${var.app_env}-logstash-inbound"
  description     = "security group that allows logstash/kibana traffic inbound"
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      # add your ip here
      cidr_blocks = ["162.40.29.3/32"]
  }

  ingress {
      from_port   = 5601
      to_port     = 5601
      protocol    = "tcp"
      # add your ip here
      cidr_blocks = ["162.40.29.3/32"]
  }

  ingress {
      from_port   = 1514
      to_port     = 1514
      protocol    = "tcp"
      # add your ip here
      cidr_blocks = ["162.40.29.3/32"]
  }

  ingress {
      from_port   = 5601
      to_port     = 5601
      protocol    = "tcp"
      # add your ip here
      cidr_blocks = ["10.0.10.0/24","10.0.20.0/24"]
  }

  tags {
    Name = "${var.app_name}-${var.app_env}-logstash-inbound"
  }
}
