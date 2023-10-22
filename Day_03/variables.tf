variable "ami_id_value" {
  description = "AMI ID of ec2 instance"
  type        = string
}

variable "instance_type_value" {
  description = "Instance type of ec2"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

variable "desired_size" {
  description = "The desired number of EC2 Instances in the ASG"
  type        = number
}

variable "key_pair_name_value" {
  description = "Key pair for ssh into EC2"
  type        = string
}


variable "greeter_name" {
  type        = string
  description = "Person who will greet user on website"
}

variable "aws_region" {
  type        = string
  description = "Region in which you want to launch resources"
}
