provider "aws" {
  region = var.aws_region
}


module "webserver-cluster" {
  source = "./modules/webserver-cluster"

  ami_id_value        = var.ami_id_value
  instance_type_value = var.instance_type_value
  key_pair_name_value = var.key_pair_name_value
  greeter_name        = var.greeter_name
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size

}


output "alb-endpoint" {
  value       = module.webserver-cluster.alb-endpoint
  description = "ALB endpoint value"
}

output "path_module" {
  value = module.webserver-cluster.path_module
}

output "path_root" {
  value = module.webserver-cluster.path_root
}

output "path_cwd" {
  value = module.webserver-cluster.path_cwd
}
