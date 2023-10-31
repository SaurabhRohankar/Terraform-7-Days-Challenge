provider "aws" {
    region = "ap-south-1"
}

resource "aws_s3_bucket" "my-state-file-s3-bucket" {
    bucket = var.bucket_name
    
    # Prevent accidental deletion of this S3 aws_s3_bucket
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.my-state-file-s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.my-state-file-s3-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.my-state-file-s3-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_dynamodb_table" "terraform_state_lock_table" {
  name = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
