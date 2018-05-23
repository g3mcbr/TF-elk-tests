resource "aws_elb" "internal_elb" {
  name                = "${var.app_name}-${var.app_env}-internal-elb"
  subnets             = ["${var.private_subnet_ids}"]
  security_groups     = ["${var.vpc_default_sg_id}"]
  internal            = true

  listener {
    lb_port           = 9200
    lb_protocol       = "http"
    instance_port     = 9200
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    target              = "HTTP:9200/"
    timeout             = 3
    interval            = 30
  }
}
resource "aws_elb" "logstash_internal_elb" {
  name                = "${var.app_name}-${var.app_env}-logstash-internal-elb"
  subnets             = ["${var.private_subnet_ids}"]
  security_groups     = ["${var.vpc_default_sg_id}"]
  internal            = true

  listener {
    lb_port           = 5000
    lb_protocol       = "tcp"
    instance_port     = 5000
    instance_protocol = "tcp"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    target              = "TCP:5000"
    timeout             = 3
    interval            = 30
  }
}
