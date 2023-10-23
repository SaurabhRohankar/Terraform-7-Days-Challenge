# Terraform 7-Days Challenge

This repository is part of a 7-day Terraform challenge, where we'll gradually build an infrastructure as code using Terraform over the course of seven days. Each day's progress will be documented in this README.

## Day 1 - Launching an EC2 Instance in AWS

### Overview

On Day 1, we set up an AWS EC2 instance in the "ap-south-1" region, created a security group allowing HTTP and SSH access, and launched the EC2 instance with a basic user data script to serve a simple "Hello World" web page.

### Terraform Configuration

Here's a breakdown of the Terraform configuration used on Day 1:

### Day 1 Progress

1. Configured the AWS provider for the "ap-south-1" region.
2. Retrieved the default VPC ID using a data block.
3. Created an EC2 instance with an Amazon Machine Image (AMI), instance type, subnet, and user data script.
4. Defined a security group allowing inbound HTTP (port 80) and SSH (port 22) traffic.
5. Outputs VPC ID and public IP address of the EC2 instance.

### Next Steps

Stay tuned for Day 2, where we'll continue building on this infrastructure.

## How to Use

1. Install Terraform on your local machine if you haven't already.
2. Clone this repository.
3. Initialize Terraform by running `terraform init` in the repository directory.
4. Apply the configuration by running `terraform apply`.
5. Follow the prompts to confirm resource creation.
6. Once the EC2 instance is created, you can access the web page by opening the public IP address in your web browser.

## Day 2 - Load Balancer and Multiple EC2 Instances

### Overview

On Day 2, we extended our infrastructure by adding an Application Load Balancer (ALB) and multiple EC2 instances for high availability. The ALB distributes incoming traffic to these instances.

### Day 2 Progress

1. Configured the AWS provider with a variable for the region.
2. Retrieved the default VPC ID using a data block.
3. Created an ALB in public subnets across multiple availability zones.
4. Defined a target group for the ALB and attached EC2 instances to it.
5. Added an ALB listener to forward incoming HTTP traffic to the target group.
6. Configured multiple EC2 instances with a conditional variable for high availability.
7. Created security groups for the EC2 instances and the ALB.
8. Defined additional variables for flexibility.

### How to Use

1. Install Terraform on your local machine if you haven't already.
2. Clone this repository.
3. Create a `variables.auto.tfvars` file with your specific variable values, such as `aws_region`, `ami_id_value`, `instance_type_value`, `subnet_id_value`, `key_pair_name_value`, and `high_availability`.
4. Initialize Terraform by running `terraform init` in the repository directory.
5. Apply the configuration by running `terraform apply`.
6. Follow the prompts to confirm resource creation.
7. Once the resources are created, you can access the ALB endpoint to see the load-balanced web page.

## Day 3 - Modularization and EC2 Autoscaling

### Overview

On Day 3, we modularized our Terraform configuration by creating a module for a web server cluster. This module allows us to launch a scalable group of EC2 instances behind an ALB.

### Terraform Configuration - Day 3

The module structure in the `modules/webserver-cluster/` directory includes:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `user_data.sh`

Please refer to the module files for the configuration details.

### Day 3 Progress

1. Created a Terraform module for a web server cluster with a load balancer and EC2 instances.
2. Utilized the module to configure the infrastructure with variables and output values.
3. Separated the user data script into a dedicated `user_data.sh` file, making it more maintainable.
4. Added additional output values to provide information about the module path.

### How to Use - Module

1. In your main configuration, define the module using the `module` block.
2. Configure the module by providing the necessary variables.
3. Utilize the outputs from the module for any further configuration or information.


### How to Use - Root Configuration

1. Define the AWS provider configuration for the desired region.
2. Configure the `webserver-cluster` module with the required variables.
3. Utilize the outputs from the module to access the ALB endpoint and module path information.
### Cleanup

To destroy the resources created, run `terraform destroy` after you're done experimenting.

---

Stay tuned for Day 4 updates and further progress in the Terraform 7-Day Challenge!
