resource "aws_elb" "external_elb" {
  name                = "${var.app_name}-${var.app_env}-external-elb"
  subnets             = ["${var.public_subnet_ids}"]
  security_groups     = ["${var.vpc_default_sg_id}","${aws_security_group.ext-elb-inbound.id}"]
  internal            = false

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 5601
    instance_protocol = "http"
  }
  listener {
    lb_port           = 1514
    lb_protocol       = "tcp"
    instance_port     = 1514
    instance_protocol = "tcp"
  }
  listener {
    lb_port           = 55000
    lb_protocol       = "tcp"
    instance_port     = 55000
    instance_protocol = "tcp"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:5601/"
    interval            = 30
  }
}

# security group for elb
resource "aws_security_group" "ext-elb-inbound" {
  vpc_id              = "${var.vpc_id}"
  name                = "${var.app_name}-${var.app_env}-ext-elb-inbound"
  description         = "security group that allows ${var.app_name} traffic in public subnet"
  egress {
        from_port     = 0
        to_port       = 0
        protocol      = "-1"
        cidr_blocks   = ["0.0.0.0/0"]
  }
  ingress {
        from_port     = 80
        to_port       = 80
        protocol      = "tcp"
        cidr_blocks   = ["0.0.0.0/0"]
  }
  ingress {
        from_port     = 1514
        to_port       = 1514
        protocol      = "tcp"
        cidr_blocks   = ["69.23.235.72/32"]
  }
  ingress {
        from_port     = 55000
        to_port       = 55000
        protocol      = "tcp"
        cidr_blocks   = ["69.23.235.72/32"]
  }
  tags {
    Name              = "${var.app_name}-${var.app_env}-elb-inbound"
  }
}
