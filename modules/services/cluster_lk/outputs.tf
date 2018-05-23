#output "ip" {
#    value = "${aws_instance.external_host.public_ip}"
#}

output "ecs_cluster" {
  value = "${aws_ecs_cluster.cluster.id}"
}
