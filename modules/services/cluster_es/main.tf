# jaars/modules/cluster_es/main.tf

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
  template = "${file("${path.module}/ecs_user_data_with_mount.sh")}"
  vars {
  cluster_name = "ecs_${var.app_name}-${var.app_env}-${var.cluster_name}"
  }
}

resource "aws_instance" "external_host" {
  ami                         = "ami-467ca739"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(var.public_subnet_ids, 0)}"
  vpc_security_group_ids      = ["${aws_security_group.public-allow-inbound.id}","${var.vpc_default_sg_id}"]
  associate_public_ip_address = true
  key_name              = "elk-test"

  tags {
    "Name" = "external_host"
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
  security_groups       = ["${var.vpc_default_sg_id}","${aws_security_group.elastic-sg.id}"]
  iam_instance_profile  = "ecsELKInstanceRole"
  key_name              = "elk-test"
  user_data             = "${data.template_file.user_data.rendered}"

  tags {
    "Name"              = "${var.cluster_name}-docker_ecs_host-${count.index}"
    "ElasticSearch"     = "esnode"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  count         = "${length(var.private_subnet_ids)}"
  device_name   = "/dev/xvdd"
  volume_id     = "${element(var.vol_id, count.index)}"
  instance_id   = "${element(aws_instance.ecs_host.*.id, count.index)}"
  skip_destroy  = true
}

resource "aws_ecs_cluster" "cluster" {
  name = "ecs_${var.app_name}-${var.app_env}-${var.cluster_name}"
}


# security group for public inbound access
resource "aws_security_group" "public-allow-inbound" {
  vpc_id          = "${var.vpc_id}"
  name            = "${var.app_name}-${var.app_env}-allow-inbound"
  description     = "security group that allows ssh traffic inbound"
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      # add your ip here
      cidr_blocks = ["162.40.29.3/32","69.23.235.72/32"]
  }

  ingress {
      from_port   = 9200
      to_port     = 9200
      protocol    = "tcp"
      # add your ip here
      cidr_blocks = ["10.0.11.0/24","10.0.22.0/24"]
  }

  tags {
    Name = "${var.app_name}-${var.app_env}-public-inbound"
  }
}

# security group for elastic traffic
resource "aws_security_group" "elastic-sg" {
  vpc_id          = "${var.vpc_id}"
  name            = "${var.app_name}-${var.app_env}-elastic-inbound"
  description     = "security group that allows elastic traffic inbound"
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 9200
      to_port     = 9200
      protocol    = "tcp"
      # add your ip here
      cidr_blocks = ["10.0.10.0/24","10.0.20.0/24","10.0.11.0/24","10.0.22.0/24"]
  }

  ingress {
      from_port   = 9300
      to_port     = 9300
      protocol    = "tcp"
      # add your ip here
      cidr_blocks = ["10.0.11.0/24","10.0.22.0/24"]
  }


  tags {
    Name = "${var.app_name}-${var.app_env}-elastic-inbound"
  }
}
