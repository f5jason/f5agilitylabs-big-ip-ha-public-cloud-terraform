variable "web_server_ami" {
  type = map(string)

  default = {
    "us-east-1"      = "ami-a4c7edb2"
    "ap-southeast-1" = "ami-77af2014"
    "us-west-2"      = "ami-6df1e514"
  }
}
variable "aws_region" {
  description = "aws region"
#  default     = "us-west-2"
}
variable "bigIqLicenseManager" {
  description = "Management IP address of the BigIQ License Manager"
  default     = "null"
}
variable "bigIqLicensePoolName" {
  description = "BigIQ License Pool name"
  default     = "BigIQLicensePool"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 80
}
variable "emailid" {
  description = "emailid"
  default     = "student@f5lab.dev"
}
variable "emailidsan" {
  description = "emailidsan"
  default     = "studentf5labdev"
}
variable "aws_keypair" {
  description = "The name of an existing key pair. In AWS Console: NETWORK & SECURITY -> Key Pairs"
  default     = "MyKeyPair-student@f5lab.dev"
}
variable "restrictedSrcAddress" {
  type        = list(any)
  description = "Lock down management access by source IP address or network"
  default     = ["0.0.0.0/0"]
}
variable "restrictedSrcAddressVPC" {
  type        = list(any)
  description = "Lock down management access by source IP address or network"
  default     = ["10.0.0.0/16"]
}
variable "bigip_admin" {
  type    = string
  default = "admin"
}

variable "bigip_admin_password" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {}

variable "AWS_ACCESS_KEY_ID" {}

variable "AWS_CONSOLE_LINK" {}

variable "AWS_USER" {}

variable "AWS_PASSWORD" {}
