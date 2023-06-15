resource "aws_codepipeline" "codepipeline" {

  depends_on = [aws_s3_bucket.s3]
  name       = var.codepipeline_name
  role_arn   = data.aws_iam_role.iam_role_codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.s3.id
    type     = "S3"
  }
  ################################################################
  ## Source Stage
  ################################################################
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:ap-south-1:424736085230:connection/56209f90-0677-4bf4-b829-150962b653ae"
        FullRepositoryId = "kunalbhole99/spring-boot-rds"
        BranchName       = "main"
      }
    }
  }
  ################################################################
  ## Build Stage
  ################################################################
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
  ################################################################
  ## Deploy Stage
  ################################################################
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      version         = "1"
      run_order       = "1"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      region          = var.target_region
      configuration = {
        ApplicationName     = var.codedeploy_app_and_group_name
        DeploymentGroupName = var.codedeploy_app_and_group_name
      }
    }
  }


}
