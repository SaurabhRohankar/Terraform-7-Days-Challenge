provider "aws" {
  region = "ap-south-1"
}


module "webserver-cluster" {
  source = "./modules/webserver-cluster"

  ami_id_value        = "ami-0c42696027a8ede58"
  instance_type_value = "t3.micro"
  key_pair_name_value = "new-key"
  greeter_name        = "SauraXD"
  desired_size        = 3
  min_size            = 1
  max_size            = 5

}


output "alb-endpoint" {
  value       = module.webserver-cluster.alb-endpoint
  description = "ALB endpoint value"
}
