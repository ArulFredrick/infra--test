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


#POLICIES

resource "oci_identity_policy" "policy1" {
  name           = "dmone-policy"
  description    = "policy created by terraform"
  compartment_id = var.tenancy_ocid
  statements = [
    "Allow group ${var.group_name} to ${var.verb} ${var.resource_type} in compartment ${var.compartment_name}",
  ]
  
}

data "oci_identity_policies" "policies1" {
  compartment_id = var.tenancy_ocid

  filter {
    name   = "name"
    values = ["dmone-policy"]
  }
}

output "policy" {
  value = data.oci_identity_policies.policies1.policies
}

