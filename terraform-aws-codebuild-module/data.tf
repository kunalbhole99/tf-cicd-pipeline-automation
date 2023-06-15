data "aws_vpc" "vpc_available" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc"]
  }
}
data "aws_subnets" "example" {}


# data "aws_security_group" "tcw_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["sg"]
#   }
# }