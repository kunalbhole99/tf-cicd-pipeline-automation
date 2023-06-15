data "aws_vpc" "vpc_available" {
  filter {
    name   = "tag:Name"
    values = ["my_vpc"]
  }
}
data "aws_subnets" "available_db_subnet" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_available.id]
  }


  filter {
    name   = "tag:Name"
    values = ["my_vpc_database_subnet_az_*"]
  }

}

data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_security_group" "rds_sg" {
  filter {
    name   = "tag:Name"
    values = ["rds-sg"]
  }
}


