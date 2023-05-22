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
variable "compartment_ocid" {
  description = "OCID for compartment"
  type        = string
}

variable "display_name" {
  description = "Name of the subnet"
  type        = string
}
variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}