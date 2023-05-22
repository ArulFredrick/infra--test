variable "tenancy_ocid" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "compartment_ocid" {
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
default = "ap-hyderabad-1"
}

variable "integration_instance_consumption_model" {
  default = "UCM"
}