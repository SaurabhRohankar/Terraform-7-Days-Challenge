output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_ip" {
  value = aws_instance.tf-ec2[*].public_ip
}
