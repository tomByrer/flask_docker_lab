# ecs_service.tf - create a service and task definition

# Create a servic resource
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.containerName}_svc"
  cluster         = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"
  desired_count   = "${var.containerCount}"
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 50

  load_balancer {
    target_group_arn = "${aws_lb_target_group.alb_tg.arn}"
    container_name   = "${var.containerName}"
    container_port   = "${var.containerPort}"
  }

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = ["desired_count"]
  }
}

# Allow terraform variables to be rendered in ecs_taskdef.json file
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-task-definition.html
data "template_file" "ecs_taskdef" {
  template = "${file("ecs_taskdef.json")}"
  vars {
    image_name  = "${var.containerName}:${var.containerTag}"
    task_name   = "${var.containerName}"
    port        = "${var.containerPort}"
    memory      = "${var.containerMem}"
    cpu         = "${var.containerCPU}"
  }
}

# Create a task definituion
resource "aws_ecs_task_definition" "ecs_task" {
  family                = "${var.containerName}_${var.stageName}_td"
  container_definitions = "${data.template_file.ecs_taskdef.rendered}"
}