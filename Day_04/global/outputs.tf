output "s3_bucket_arn" {
  value = aws_s3_bucket.my-state-file-s3-bucket.arn
  description = "ARN of s3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_state_lock_table.name
  description = "Name of DynamoDB table"
}