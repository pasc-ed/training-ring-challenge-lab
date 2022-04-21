resource "aws_s3_bucket" "ring_challenge" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.bucket_name
    Environment = "Talent-Academy"
  }
}