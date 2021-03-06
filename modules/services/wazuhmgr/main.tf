#jaars/modules/services/wazuhmgr/main.tf

data "aws_ecs_task_definition" "app_task" {
  task_definition       = "${aws_ecs_task_definition.app_task.family}"
  depends_on            = ["aws_ecs_task_definition.app_task"]
}

resource "aws_ecs_task_definition" "app_task" {
  family                = "${var.app_name}-${var.app_env}-${var.app_svc}"
  container_definitions = "${var.container_def_json}"
  volume {
    name                = "wazuh-slave-config"
    host_path           = "/wazuh/slave"
  }
}

resource "aws_ecs_service" "app_svc" {
  name                  = "svc-${var.app_name}-${var.app_env}-${var.app_svc}"
  cluster               = "${var.cluster}"
  task_definition       = "${aws_ecs_task_definition.app_task.arn}"
  desired_count         = 2

  load_balancer {
    elb_name            = "${var.external_elb_name}"
#    target_group_arn    = "${var.target_group_arn}"
    container_name      = "wazuhmgr"
    container_port      = 1514
    }
}
