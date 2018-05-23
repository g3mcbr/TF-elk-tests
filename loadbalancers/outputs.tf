output "internal_nlb_name" {
  value = "${module.internal_nlb.internal_nlb_name}"
}

output "internal_nlb_dns_name" {
  value = "${module.internal_nlb.internal_nlb_dns_name}"
}

#output "target_group_arn" {
#  value = "${module.internal_nlb.target_group_arn}"
#}

#output "kibana_external_target_group_arn" {
#  value = "${module.external_nlb.kibana_target_group_arn}"
#}

#output "wazuh_target_group_arn" {
#  value = "${module.external_nlb.wazuh_target_group_arn}"
#}

#output "wazuh_mgr_target_group_arn" {
#  value = "${module.external_nlb.wazuh_mgr_target_group_arn}"
#}

output "logstash_target_group_arn" {
  value = "${module.internal_nlb.logstash_target_group_arn}"
}
