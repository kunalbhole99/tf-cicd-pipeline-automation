resource "aws_s3_bucket" "s3" {
  bucket        = "pipeline-artifact-store-1234567"
  force_destroy = true
}