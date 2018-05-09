#ecs_events.tf - creates SNS events for ECS cluster

resource "aws_sns_topic" "ecs_events" {
  name = "${var.projectName}_${var.stageName}_ecs_events"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "template_file" "ecs_task_stopped" {
  template = <<EOF
{
  "source": ["aws.ecs"],
  "detail-type": ["ECS Task State Change"],
  "detail": {
    "clusterArn": ["arn:aws:ecs:$${aws_region}:$${account_id}:cluster/$${cluster}"],
    "lastStatus": ["STOPPED"],
    "stoppedReason": ["Essential container in task exited"]
  }
}
EOF

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
    cluster    = "${var.projectName}_${var.stageName}_ecs_cluster"
    aws_region = "${data.aws_region.current.name}"
  }
}

resource "aws_cloudwatch_event_rule" "ecs_task_stopped" {
  name          = "${var.projectName}_${var.stageName}_ecs_cluster_task_stopped"
  description   = "${var.projectName}_${var.stageName}_ecs_cluster Essential container in task exited"
  event_pattern = "${data.template_file.ecs_task_stopped.rendered}"
}

resource "aws_cloudwatch_event_target" "event_fired" {
  rule  = "${aws_cloudwatch_event_rule.ecs_task_stopped.name}"
  arn   = "${aws_sns_topic.ecs_events.arn}"
  input = "{ \"message\": \"Essential container in task exited\", \"account_id\": \"${data.aws_caller_identity.current.account_id}\", \"cluster\": \"${var.projectName}_${var.stageName}\"}"
}