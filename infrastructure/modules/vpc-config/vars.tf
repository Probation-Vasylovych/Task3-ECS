variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
    type              = string
  }))
}

variable "vpc_id" {
  description = "VPC id where recources will be created"
  type = string
}

variable "env" {
  description = "Environment variable"
  type = string
}

variable "common_tags" {
  description = "Tags for resources"
  type = map(string)
}