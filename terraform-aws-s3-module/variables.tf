variable "bucket_name" {
  type    = string
  default = "kunalbucket12345678"
}


variable "bucket_acl_type" {
  type    = string
  default = "private"
}

variable "bucket_versioning" {
  type    = string
  default = "Disabled"
}

variable "log_bucket_name" {
  type    = string
  default = "my-log-bucket"
}

variable "folder_name" {
  type    = string
  default = "myrepo/"
}