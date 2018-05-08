# Flask Docker Lab developer desktop

This directory contains everything required to build the developer
desktop used in this flask_docker_lab.

The developer's desktop image is created using packer (dev_desk.json)

The image can be deployed using terraform (deploy.tf)

# Steps

1. [Install packer](https://www.packer.io/docs/install/index.html#precompiled-binaries)

2. [Install terraform](https://www.terraform.io/intro/getting-started/install.html)

3. [Install the aws cli](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)

4. Set your $AWS_PROFILE to the correct aws account as defined in ~/.aws/credentials.
	See [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html)
	for more info about the aws cli credentials file
	
		export AWS_PROFILE=XXXX

5. Build the ubuntu developer desktop AMI in your account

		packer build dev_desk.json

6. Deploy the developer desktop using terraform

		terraform init
		terraform plan
		terraform apply

7. Connect to the developer desktop public_ip with a VNC client on port 5901 with a VNC client. 
	The password is `dockerlab`

8. When you are done with the lab, termanate the developer desktop

		terraform destroy
