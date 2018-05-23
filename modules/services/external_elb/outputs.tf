output "external_elb_name" {
  value = "${aws_elb.external_elb.name}"
}

output "external_elb_dns_name" {
  value = "${aws_elb.external_elb.dns_name}"
}
