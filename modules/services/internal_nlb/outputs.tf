output "internal_nlb_name" {
  value = "${aws_lb.internal_nlb.name}"
}

output "internal_nlb_dns_name" {
  value = "${aws_lb.internal_nlb.dns_name}"
}

#output "target_group_arn" {
#  value = "${aws_lb_target_group.internal_tg.arn}"
#}

output "logstash_target_group_arn" {
  value = "${aws_lb_target_group.logstash_internal_tg.arn}"
}
