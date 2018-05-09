# ecs_iam.tf - create the roles required for ECS cluster instances

# Why we need ECS instance policies http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
# ECS roles explained here http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_managed_policies.html
# Some other ECS policy examples http://docs.aws.amazon.com/AmazonECS/latest/developerguide/IAMPolicyExamples.html

##########################################################
# EC2 Role for connectinb to ECS & Logwatch

# Create a new role for the EC2 ECS Instances
resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.projectName}_${var.stageName}_ecs_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Create an instance profile that we can attach to the ECS ASG
resource "aws_iam_instance_profile" "ecs" {
  name = "${var.projectName}_${var.stageName}_ecs_instance_profile"
  path = "/"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

# Attach EC2 Conatiner Service Policy
resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = "${aws_iam_role.ecs_instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# Attach Cloudwatch Logs Policy
resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = "${aws_iam_role.ecs_instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

#############################################
# EC2 Service Role for registering tasks with ALB

# Role for the ECS service definition
resource "aws_iam_role" "ecs_service_role" {
  name = "${var.projectName}_${var.stageName}_ecs_service_role"
  path = "/ecs/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach EC2 Container Service Policy
resource "aws_iam_role_policy_attachment" "ecs_service_attach" {
  role       = "${aws_iam_role.ecs_service_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
