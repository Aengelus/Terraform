# This defines the region variables within your Terraform configuration. There is a default value, but is optional. Otherwise, If no default is set, the variable is required.
# access the variable using var. and the  name of the variable, here it would be var.region
variable "region" {
  default = "us-east-1"
}