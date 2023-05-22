

terraform {
    required_providers {
      oci = {
        source = "hashicorp/oci"
      }
    }
  }
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

# USERS

 resource "oci_identity_user" "user1" {
  name           = "dmone-usr"
  email          = "dmone-user@oracle.com"
  description    = "user created by terraform"
  compartment_id = var.tenancy_ocid
}

 data "oci_identity_users" "users1" {
  compartment_id = oci_identity_user.user1.compartment_id

  filter {
    name   = "name"
    values = ["dmone-usr"]
  }
}

output "users1" {
  value = data.oci_identity_users.users1.users
}

resource "oci_identity_ui_password" "password1" {
  user_id = oci_identity_user.user1.id
}

data "oci_identity_ui_password" "test_ui_password" {
  user_id = oci_identity_user.user1.id
}

output "user-password" {
  sensitive = false
  value     = oci_identity_ui_password.password1.password
}