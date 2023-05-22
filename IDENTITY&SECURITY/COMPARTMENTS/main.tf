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

# COMPARTMENTS

resource "oci_identity_compartment" "compartment1" {
  name           = "dmone-cmp"
  description    = "compartment created by terraform"
  compartment_id = var.tenancy_ocid
  enable_delete  = true // true will cause this compartment to be deleted when running `terrafrom destroy`
}

data "oci_identity_compartments" "compartments1" {
  compartment_id =oci_identity_compartment.compartment1.compartment_id

  filter {
    name   = "name"
    values = ["dmone-cmp"]
  }
}

output "compartments" {
  value = data.oci_identity_compartments.compartments1.compartments[0].id
}