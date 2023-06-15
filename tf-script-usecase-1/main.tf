module "vpc" {
  source = "../terraform-aws-vpc-module"

}

module "ec2" {
  source     = "../terraform-aws-ec2-module"
  depends_on = [module.vpc]

  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source     = "../terraform-aws-rds-module"
  depends_on = [module.vpc]
}

