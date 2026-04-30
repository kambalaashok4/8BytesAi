variable "project_name" {
  description = "Prefix used for all resource names"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "hosted_zone_name" {
  description = "Domain name for the Route 53 hosted zone (e.g. example.com). Must be a domain you control so ACM DNS validation can succeed."
  type        = string
  default = "umbrella.in"
}