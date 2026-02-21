package terraform.security

deny[msg] {
  input.resource_changes[_].change.after.ingress[_].cidr_blocks[_] == "0.0.0.0/0"
  msg := "Public ingress detected"
}