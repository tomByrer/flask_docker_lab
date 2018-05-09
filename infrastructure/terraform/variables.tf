# variables.tf – commonly configured parameters for our environment (i.e. projectName)

#################################################
# AWS Region
variable "region" {
	default = "us-west-2"
}
variable "availZones" {
	type = "list"
	default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

#################################################
# Project naming

variable "projectName" {
	default = "dockerlab"
}
variable "stageName" {
	default = "dev"
}
variable "costCenter" {
	default = "1234.5678"
}

##################################################
# Conatiner Info

# containerName hould match the container name in docker-compose.yml
variable "containerName" {
	default = "flask_docker_lab"
}
# Use to define which tagged version in the ECR repo to deploy
variable "containerTag" {
	#default = "latest"
	default = "v1.0"
}
# The port on which our container is listening
variable "containerPort" {
	default = 5000
}
# How many instances of our container to deploy
variable "containerCount" {
	default = 2
}
# How much memory to allocate to each conatiner
variable "containerMem" {
	default = 512
}
# How much cpu to allocate to each conatiner
variable "containerCPU" {
	default = 256 # (.25 CPU)
}

#################################################
# EC2 ECS Cluster servers

# ECS Instances
variable "ecsAmiName" {
	default = "amzn-ami-*-amazon-ecs-optimized"
}
variable "ecsInstanceType" {
	default = "t2.micro"
}

# Autoscaling Group
variable "tgtGrpDesiredSize" {
	default = "2"
}
variable "tgtGrpMinSize" {
	default = "2"
}
variable "tgtGrpMaxSize" {
	default = "2"
}
variable "healthCheckGracePeriod" {
	#default = "300" # a sane number
	default = "90" # faster for testing
}

###############################################################
# Network Vars

variable "vpcCidr" {
	default = "10.0.0.0/16"
}
variable "publicCidrs" {
	type = "list"
	default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "appCidrs" {
	type = "list"
	default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}
