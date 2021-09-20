variable "cluster_name" {
  description = "Name used for the Cluster"
  type = string
}

variable "name_prefix" {
  description = "Prefix used for several resource names"
  type = string
}

variable "region" {
  description = "Region where the Cluster will be created"
  default = "eu-west-1"
  type = string
}

variable "region_zone_01" {
  description = "First region zone"
  default = "eu-west-1a"
  type = string
}

variable "region_zone_02" {
  description = "Second region zone"
  default = "eu-west-1b"
  type = string
}

variable "region_zone_03" {
  description = "Third region zone"
  default = "eu-west-1c"
  type = string
}
