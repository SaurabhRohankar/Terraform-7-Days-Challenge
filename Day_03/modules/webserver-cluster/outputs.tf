output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_subnet_ids" {
  value = data.aws_subnets.public_subnets.ids
}

output "alb-endpoint" {
  value = aws_lb.test.dns_name
}
