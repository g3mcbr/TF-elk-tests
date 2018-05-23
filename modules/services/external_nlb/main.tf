#jaars/modules/external_nlb/main.tf

resource "aws_lb" "external_nlb" {
  name                = "${var.app_name}-${var.app_env}-ecs-external-nlb"
  internal            = false
  load_balancer_type  = "network"
  subnets             = ["${var.public_subnet_ids}"]

  tags {
    name              = "${var.app_name}-${var.app_env}-external_nlb"
  }
}

####external target group for kibana
resource "aws_lb_target_group" "external_kibana_tg" {
  name                  = "${var.app_name}-${var.app_env}-kibana-tg"
  port                  = 5601
  protocol              = "TCP"
  vpc_id                = "${var.vpc_id}"
  stickiness            = []

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = 5601
    interval            = 30
  }
}

resource "aws_lb_listener" "external_kibana_listener" {
  load_balancer_arn   = "${aws_lb.external_nlb.arn}"
  port                = 80
  protocol            = "TCP"

  default_action {
    target_group_arn  = "${aws_lb_target_group.external_kibana_tg.arn}"
    type              = "forward"
  }
}

#####target group for wazuh agent
resource "aws_lb_target_group" "wazuh_tg" {
  name                  = "${var.app_name}-${var.app_env}-wazuh-tg"
  port                  = 1514
  protocol              = "TCP"
  vpc_id                = "${var.vpc_id}"
  stickiness            = []

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
#    protocol            = "TCP"
    port                = 1514
    interval            = 30
#    matcher             = "200-499"
  }
}

resource "aws_lb_listener" "wazuh_listener" {
  load_balancer_arn   = "${aws_lb.external_nlb.arn}"
  port                = 1514
  protocol            = "TCP"

  default_action {
    target_group_arn  = "${aws_lb_target_group.wazuh_tg.arn}"
    type              = "forward"
  }
}

#####target group for wazuh manager
resource "aws_lb_target_group" "wazuh_mgr_tg" {
  name                  = "${var.app_name}-${var.app_env}-wazuh-mgr-tg"
  port                  = 55000
  protocol              = "TCP"
  vpc_id                = "${var.vpc_id}"
  stickiness            = []

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = 8080
    interval            = 30
    path                = "/"
#    matcher             ="200"
  }
}

resource "aws_lb_listener" "wazuh_mgr_listener" {
  load_balancer_arn   = "${aws_lb.external_nlb.arn}"
  port                = 55000
  protocol            = "TCP"

  default_action {
    target_group_arn  = "${aws_lb_target_group.wazuh_mgr_tg.arn}"
    type              = "forward"
  }
}
