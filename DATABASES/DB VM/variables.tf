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

variable "compartment_ocid" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "ssh_public_key" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "ssh_private_key" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "region" {
default     = "ap-hyderabad-1"
}

variable "db_system_shape" {
  default = "VM.Standard2.2"
}

variable "cpu_core_count" {
  default = "1"
}

variable "db_edition" {
  default = "ENTERPRISE_EDITION_HIGH_PERFORMANCE"
}

variable "db_admin_password" {
  default = "DEVdbfor_#123"
}

variable "db_version" {
  default = "19.17.0.0"
}

variable "db_disk_redundancy" {
  default = "NORMAL"
}

variable "sparse_diskgroup" {
  default = true
}

variable "db_system_display_name" {
  default = "DBSystem"
}

variable "hostname" {
  default = "mydmonedb"
}

variable "host_user_name" {
  default = "opc"
}

variable "n_character_set" {
  default = "AL16UTF16"
}

variable "character_set" {
  default = "AL32UTF8"
}

variable "db_workload" {
  default = "OLTP"
}

variable "pdb_name" {
  default = "pdb1"
}

variable "data_storage_size_in_gb" {
  default = "256"
}

variable "license_model" {
  default = "LICENSE_INCLUDED"
}

variable "node_count" {
  default = "1"
}
variable "subnet_id" {
 type        = string
}
