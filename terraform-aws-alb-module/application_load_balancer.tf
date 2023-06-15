###################################################################
## Application Load Balancer
##################################################################

resource "aws_lb" "applications_load_balancer" {
  name                             = var.application_load_balancer_name
  internal                         = var.internal_or_internet_facing
  load_balancer_type               = var.loadBalancer_type
  security_groups                  = data.aws_security_groups.alb_sg.ids
  drop_invalid_header_fields       = var.drop_invalid_header_alb
  idle_timeout                     = var.timeout_idle_alb
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing_nlb
  #subnets                          = [for s in data.aws_subnet.private : s.id]
  subnets = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id ]

  access_logs {
    bucket  = aws_s3_bucket.alb_logging.id
    prefix  = var.application_load_balancer_name
    enabled = true
  }

  depends_on = [ aws_s3_bucket.alb_logging, 
  aws_s3_bucket_policy.alb_bucket_policy,
  aws_s3_bucket_acl.bucket_acl,
  aws_s3_bucket_ownership_controls.example ]

  tags = {
    Environment = var.alb_environment_tag
  }
}

############# S3 bucket for ALB access logging ##################

resource "aws_s3_bucket" "alb_logging" {
  bucket = var.alb_logging_bucket_name
  force_destroy = true
  
  logging {
    target_bucket = var.alb_logging_bucket_name
    target_prefix = "AWSLogs/"
  }

  tags   = {
    Name = "alb_bucket_logs"
  }

}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.alb_logging.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.example]
  bucket     = aws_s3_bucket.alb_logging.id
  acl        = var.bucket_acl_type
}


resource "aws_s3_bucket_policy" "alb_bucket_policy" {
  bucket = aws_s3_bucket.alb_logging.id

  policy = <<EOF
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::718504428378:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.alb_logging_bucket_name}/*"
        }
    ]
}
EOF
}

