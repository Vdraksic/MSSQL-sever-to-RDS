variable "RDSallocatedstorage" {
  type = number

}

variable "engine_ver" {
  type = string

}

variable "engine" {
  type = string

}

variable "instance_class" {
  type = string

}

variable "backup_retention_period" {
  type = number

}

variable "backup_window" {
  type = string

}

variable "max_allocated_storage" {
  type = number

}

variable "option_group_ver" {
  type = string

}

variable "identifier" {
  type = string

}

variable "port" {
  type = string

}

variable "monitoring_interval" {
  type = number

}

variable "subnet1" {
  type = string

}

variable "subnet2" {
  type = string

}

variable "security_group" {
  type = string

}

variable "storage_type" {
  type = string

}

variable "DB_username" {
  type      = string
  sensitive = true

}

variable "DB_password" {
  type      = string
  sensitive = true
}