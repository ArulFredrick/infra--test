variable "tenancy_ocid" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "region" {
  description = "OCID for region"
  type        = string
}

variable "user_ocid" {
  description = "OCID for the user"
  type        = string
}

variable "fingerprint" {
  description = "OCID for fingerprint"
  type        = string
}

variable "private_key_path" {
  description = "OCID private key path"
  type        = string
}
variable "group_name" {
  description = "Enter the name of the group"
  type        = string
}
variable "compartment_name" {
  description = "Enter name of the compartment"
  type        = string
}
variable "resource_type" {
  description = "Enter type of resource"
  type        = string
}
variable "verb" {
  description = "Enter the verb"
  type        = string
}
