variable "tenancy_ocid" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "user_ocid" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "fingerprint" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "private_key_path" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "region" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "compartment_ocid" {
  description = "OCID from your tenancy page"
  type        = string
}


variable "db_version" { 
type = string 
}

variable "db_name" { 
type = string 
}

variable "db_workload" { 
type = string 
}

variable "is_free_tier" { 
type = string 
}

variable "admin_password" { 
type = string 
}

variable "license_model" { 
type = string 
}

variable "cpu_core_count" {
  type    = number
  default = 1
}

variable "data_storage_size_in_tbs" {
  type    = number
  default = 1
}
