# ecs_cluster.tf - builds the ECS cluster

resource "aws_ecs_cluster" "cluster" {
  name = "${var.projectName}_${var.stageName}_ecs_cluster"
}

resource "aws_ecr_repository" "repository" {
  name = "${var.projectName}_${var.stageName}_ecr"
}
