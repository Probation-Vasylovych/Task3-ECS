variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "service_name" {
  type = string
}

variable "namespace_id" {
  type = string
}

variable "ttl" {
  type    = number
  default = 10
}

variable "common_tags" {
  type    = map(string)
  default = {}
}