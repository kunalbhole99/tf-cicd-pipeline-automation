# data "aws_s3_bucket" "s3_bucket_artifact_store" {
#   bucket = "pipeline-artifact-store"
# }

data "aws_iam_role" "iam_role_codepipeline" {
  name = "codepipeline"
}