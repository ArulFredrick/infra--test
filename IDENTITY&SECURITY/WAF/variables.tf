variable "tenancy_ocid" {
 description = "OCID from your tenancy page"
 type        = string
}

variable "compartment_ocid" {
 description = "OCID from your tenancy page"
 type        = string
}

variable "load_balancer_ocid" {
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

variable "waf_policy_display_name" {
  default = "dm-waf"
}

variable "waf_web_app_firewall" {
  default = "tf_example_waf_web_app_firewall"
}