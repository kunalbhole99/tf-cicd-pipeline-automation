######################################################
## Data to fetch VPC details
######################################################

data "aws_availability_zone" "az" {
  state = "available"
  name  = "ap-south-1a"
}


data "aws_vpc" "vpc_selected" {
  filter {
    name   = "tag:Name"
    values = ["my_vpc"]
  }
}

###################################################################
## Data to be fetched for subnets
##################################################################

data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = ["my_vpc_public_subnet_az_1a"]
  }
}


data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = ["my_vpc_public_subnet_az_1b"]
  }
}

####### Security group data block #######
data "aws_security_groups" "alb_sg" {
  tags = {
    Name = "alb-sg"
  }
}

data "aws_security_groups" "ec2_sg" {
  tags = {
    Name = "ec2-sg"
  }
}

########### key pair & IAM role data block ############

data "aws_key_pair" "key" {
  key_name = "awskeypair"
}


data "aws_iam_instance_profile" "instance_profile" {
  name = "SSM-Role-For-EC2"
}


/*
#----------------------------------------------------
data "aws_subnets" "private1" {
  filter {
    name   = "tag:Name"
    values = ["my_vpc_public_subnet_az_*"]
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnets.private1.ids
  id       = each.value
}


*/