resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

}

# ACL policy grant:
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.example]
  bucket     = aws_s3_bucket.bucket.id
  acl        = var.bucket_acl_type
}

# bucket versioning :

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.bucket_versioning
  }
}

# s3 bucket for logging:

resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
}


resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowLogDelivery",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : ["cloudtrail.amazonaws.com", "logs.ap-south-1.amazonaws.com"]
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.log_bucket.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}


# s3 bucket object creation:

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = var.folder_name
}