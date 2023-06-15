data "aws_iam_instance_profile" "instance_profile" {
  name = "SSM-Role-For-EC2"
}
data "aws_availability_zone" "az" {
  name                   = "ap-south-1a"
  all_availability_zones = false
  state                  = "available"
}
data "aws_key_pair" "key" {
  key_name = "awskeypair"
}

data "aws_vpc" "vpc_available" {
  filter {
    name   = "tag:Name"
    values = ["my_vpc"]
  }
}


data "aws_subnet" "selected" {
  vpc_id            = data.aws_vpc.vpc_available.id
  availability_zone = "ap-south-1a"
  filter {
    name   = "tag:Name"
    values = ["my_vpc_public_subnet_az_*"]
  }
}
data "aws_security_groups" "ec2_sg" {
  tags = {
    Name = "ec2-sg"
  }
}