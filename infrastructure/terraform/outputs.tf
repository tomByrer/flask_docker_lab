# output.tf - outputs important parameters will need to finish configuring vault
# These parameters will but spit out after each terraform apply

output "LOADBALANCER_DNS" {
	value = "${aws_alb.alb.dns_name}"
}

output "ECR_REPOSITORY" {
	value = "${aws_ecr_repository.repository.name}"
}
