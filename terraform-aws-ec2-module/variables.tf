variable "vpc_id" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}
variable "ami_id" {
  type    = string
  default = "ami-03cb1380eec7cc118"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "associate_public_ip" {
  type    = bool
  default = true
}
variable "az" {
  type    = string
  default = "ap-south-1a"
}
variable "disable_api_termination" {
  type    = bool
  default = false
}
variable "instance_profile" {
  type    = string
  default = "ec2"
}
variable "key" {
  type    = string
  default = "awskeypair"
}
variable "sg" {
  type    = list(any)
  default = ["sg-0351b4c3f02a5d4c1"]
}
variable "subnet_id" {
  type    = string
  default = "subnet-006413b71c0a77fc9"
}
variable "volume_size" {
  type    = number
  default = 10
}
variable "application" {
  type    = string
  default = "tcw"
}
variable "organization" {
  type    = string
  default = "thecloudworld"
}

