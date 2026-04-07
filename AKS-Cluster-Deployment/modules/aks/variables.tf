variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "aks_subnet_id" {
  type = string
}

variable "agic_subnet_id" {
  type = string
}

/*
variable "log_analytics_id" {
  type = string
}
*/

variable "system_vm_size" { 
  type = string
}

/*
variable "system_node_count" {
  type = number
}
*/

variable "system_min_count" {
  type = number
}

variable "system_max_count" {
  type = number
}