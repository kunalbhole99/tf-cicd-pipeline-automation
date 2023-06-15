variable "codepipeline_name" {
  type    = string
  default = "pipeline"
}
variable "build_stage" {
  type    = string
  default = false
}
variable "source_repo_name" {
  description = "Enter the source repository name with Organization name"
  type        = string
  default     = "kunalbhole99/spring-boot-rds"
}
variable "branch_name" {
  description = "Branch name"
  type        = string
  default     = "main"
}
variable "codebuild_project_name" {
  description = "Enter the codebuild project name"
  type        = string
  default     = "demoproject"
}
variable "codedeploy_app_and_group_name" {
  description = "Enter the app name of codedeploy"
  type        = string
  default     = "codedeploy"
}
variable "target_region" {
  description = "Enter the region name where the action needs to be taken"
  type        = string
  default     = "ap-south-1"
}