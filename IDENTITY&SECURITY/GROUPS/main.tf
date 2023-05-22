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

#GROUPS
resource "oci_identity_group" "group1" {
  name           = "dmone-grp"
  description    = "group created by terraform"
  compartment_id = var.tenancy_ocid
}

data "oci_identity_groups" "groups1" {
  compartment_id = oci_identity_group.group1.compartment_id

  filter {
    name   = "name"
    values = ["dmone-grp"]
  }
}
output "groups" {
  value = data.oci_identity_groups.groups1.groups
}



