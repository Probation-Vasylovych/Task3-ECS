locals {
  public_subnets = {
    for k, v in var.subnets : k => v
    if v.public
  }

  private_subnets = {
    for k, v in var.subnets : k => v
    if !v.public
  }
}