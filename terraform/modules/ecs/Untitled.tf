provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data-bucket01" {
  bucket = "data-bucket-01"
  region = "us-east-1"
  
}

output "aws_s3_bucket" {
    value = aws_s3_bucket.data-bucket01.bucket
  
}

