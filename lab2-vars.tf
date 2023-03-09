variable "bigip1_private_ip" {
  type    = list(any)
  default = ["10.0.1.50", "10.0.1.51", "10.0.1.52", "10.0.1.53", "10.0.1.54"]
}

variable "bigip2_private_ip" {
  type    = list(any)
  default = ["10.0.2.60", "10.0.2.61", "10.0.2.62", "10.0.2.63", "10.0.2.64"]
}

variable "bigip1_default_route" {
  type    = string
  default = "10.0.1.1"
}
variable "bigip2_default_route" {
  type    = string
  default = "10.0.2.1"
}

