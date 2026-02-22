variable "github_username" {}
variable "github_repo" {}
variable "local_source_ip" {
  description = "Local IP in CIDR"
  type        = string
}
variable "region" {}
variable "instance_type" {}