variable "access_key" {}
variable "secret_key" {}

/* Global variables */
variable "keypair" {}
variable "keyfile" {}

/* Region-specific setup is below. Uses
   multiple regions, "primary" & "backup" for DR. */

variable "region" {
  default { 
    "primary" = "us-west-2"
    "backup" = "us-east-1"
  }
}

variable "insttype" {
  default = {
    "utility" = "t2.micro"
    "chef-client" = "t2.micro"
  }
}

variable "ami" {
  default = {
    "us-east-1" = "ami-8fcee4e5"
    "us-west-2" = "ami-3d5db05d" #based on public Amazon ami "ami-63b25203"
    "platform" = "AmazonLinux"
  }
}

variable "azones" {
  default = {
    "us-east-1" = "us-east-1b,us-east-1c"
    "us-west-2" = "us-west-2a,us-west-2b"
  }
}
