#jaars/modules/internal_nlb/main.tf

resource "aws_lb" "internal_nlb" {
  name                = "${var.app_name}-${var.app_env}-ecs-internal-nlb"
  internal            = true
  load_balancer_type  = "network"
  subnets             = ["${var.private_subnet_ids}"]

  tags {
    name              = "${var.app_name}-${var.app_env}-internal_nlb"
  }
}

########initial tg for elasticsearch
#resource "aws_lb_target_group" "internal_tg" {
#  name                  = "${var.app_name}-${var.app_env}-internal-tg"
#  port                  = 9200
#  protocol              = "TCP"
#  vpc_id                = "${var.vpc_id}"
#  stickiness            = []
#
#  health_check {
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#    port                = 9200
#    interval            = 30
#  }
#}

#resource "aws_lb_listener" "ecs_listener" {
#  load_balancer_arn   = "${aws_lb.internal_nlb.arn}"
#  port                = 9200
#  protocol            = "TCP"
#
#  default_action {
#    target_group_arn  = "${aws_lb_target_group.internal_tg.arn}"
#    type              = "forward"
#  }
#}

######initial tg for logstash
resource "aws_lb_target_group" "logstash_internal_tg" {
  name                  = "${var.app_name}-${var.app_env}-internal-tg"
  port                  = 5000
  protocol              = "TCP"
  vpc_id                = "${var.vpc_id}"
  stickiness            = []

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "TCP"
    port                = 5000
    interval            = 30
  }
}

resource "aws_lb_listener" "logstash_internal_listener" {
  load_balancer_arn   = "${aws_lb.internal_nlb.arn}"
  port                = 5000
  protocol            = "TCP"

  default_action {
    target_group_arn  = "${aws_lb_target_group.logstash_internal_tg.arn}"
    type              = "forward"
  }
}
