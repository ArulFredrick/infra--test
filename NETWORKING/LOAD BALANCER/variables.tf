variable "compartment_ocid" {
  description = "OCID from your tenancy page"
  type        = string
}
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
variable "subnet_id"{
  type = string
}

variable "region"{
  type = string
}
variable "private_ip"{
  type = string
}
variable "trusted_certificate_authority_ids" {
  type = list(string)
  default = ["id1"]
}
variable "certificate_ids" {
  description = "OCID from your tenancy page"
  type        =list(string)
  default = ["certificate_id1"]
}