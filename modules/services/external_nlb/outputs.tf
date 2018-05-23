output "external_nlb_name" {
  value = "${aws_lb.external_nlb.name}"
}

output "external_nlb_dns_name" {
  value = "${aws_lb.external_nlb.dns_name}"
}

output "kibana_target_group_arn" {
  value = "${aws_lb_target_group.external_kibana_tg.arn}"
}

output "wazuh_target_group_arn" {
  value = "${aws_lb_target_group.wazuh_tg.arn}"
}

output "wazuh_mgr_target_group_arn" {
  value = "${aws_lb_target_group.wazuh_mgr_tg.arn}"
}
