output "internal_elb_name" {
  value = "${aws_elb.internal_elb.name}"
}

output "internal_elb_dns_name" {
  value = "${aws_elb.internal_elb.dns_name}"
}
output "logstash_internal_elb_name" {
  value = "${aws_elb.logstash_internal_elb.name}"
}

output "logstash_internal_elb_dns_name" {
  value = "${aws_elb.logstash_internal_elb.dns_name}"
}
