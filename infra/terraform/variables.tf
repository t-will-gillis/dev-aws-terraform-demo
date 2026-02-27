variable "github_username" {
  description = "GitHub username for the repo"
  default     = "t-will-gillis"
}

variable "github_repo" {
  description = "GitHub repo name"
  default     = "dev-aws-terraform-demo"
}

variable "local_source_ip" {
  description = "Local IP in CIDR (via GitHub secrets)"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}