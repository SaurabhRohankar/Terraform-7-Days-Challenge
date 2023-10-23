output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_subnet_ids" {
  value = data.aws_subnets.public_subnets.ids
}

output "alb-endpoint" {
  value = aws_lb.test.dns_name
}

output "path_module" {
  value = "${path.module} this is path module"
}

output "path_root" {
  value = path.root
}

output "path_cwd" {
  value = path.cwd
}
