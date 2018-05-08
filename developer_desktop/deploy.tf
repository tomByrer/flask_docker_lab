# deploy.tf - Deploys the developer desktop image created by packer

# work in Oregon region
provider "aws" {
  region = "us-west-2"
}

# Find the latest AMI created
data "aws_ami" "flask_docker_lab_desktop_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["flask_docker_lab/developer_desktop-*"]
  }
}

# Get the default VPC
data "aws_vpc" "default" {
	default = "true"
}

# Create the Desktop instance
resource "aws_instance" "desktop" {
  ami           = "${data.aws_ami.flask_docker_lab_desktop_ami.id}"
  instance_type = "c5.large"
	security_groups = ["${aws_security_group.flask_docker_lab_desktop_sg.name}"]
	iam_instance_profile = "${aws_iam_instance_profile.ec2admin_profile.name}"
	root_block_device {
		volume_size = "16"
	}
  tags {
    Name = "flask_docker_lab_desktop"
  }
}

# The security group
resource "aws_security_group" "flask_docker_lab_desktop_sg" {
  name        = "flask_docker_lab_desktop_sg"
  description = "Flask Docker Lab Developer Desktop Security Group"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5901
    to_port     = 5901
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create a ec2admin role that we can attach to an EC2 instance
resource "aws_iam_role" "ec2admin_role" {
	name = "ec2admin-role"
	description = "Admin role for EC2"
	assume_role_policy = <<EOF
{
	"Version":"2012-10-17",
	"Statement":[
		{
			"Sid":"",
			"Effect":"Allow",
			"Principal":{"Service":"ec2.amazonaws.com"},
			"Action":"sts:AssumeRole"
		}
	]
}
EOF
}

# Attach an admin policy to the ec2admin role 
resource "aws_iam_role_policy" "admin_policy" {
  name = "ec2admin_policy"
	role = "${aws_iam_role.ec2admin_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

# Create an IAM instance profile that allows us to attach the IAM role to EC2 instance
resource "aws_iam_instance_profile" "ec2admin_profile" {
  name = "ec2admin_profile"
  role = "${aws_iam_role.ec2admin_role.name}"
}

output "DESKTOP_IP" {
	value = "${aws_instance.desktop.public_ip}"
}
