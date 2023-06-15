module "codebuild" {
  source = "../terraform-aws-codebuild-module"
}

module "codedeploy" {
  source = "../terraform-aws-codedeploy-module"

  # enable_bluegreen = true
  # rollback_enabled = true
  # alb_target_group = "yes"
}

module "codepipeline" {
  source = "../terraform-aws-codepipeline-module"

}