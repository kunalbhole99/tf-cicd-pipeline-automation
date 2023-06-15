module "vpc" {
  source = "../terraform-aws-vpc-module"
}


module "rds" {
  source = "../terraform-aws-rds-module"
  depends_on = [ module.vpc ]
}


module "alb_asg_ec2" {
  source = "../terraform-aws-alb-module"

  depends_on = [ module.vpc ]
}