terraform {
    required_providers {
      oci = {
        source = "hashicorp/oci"
      }
    }
  }

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

 
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_core_vcn" "vcn" {
  vcn_id = "ocid1.vcn.oc1.ap-hyderabad-1.amaaaaaabqwifqiapfwvviylqjxxt6ts5wtgl2jjcq3cioxw6piauqpxel4a"
}

data "oci_core_subnet" "subnet" {
  subnet_id = "ocid1.subnet.oc1.ap-hyderabad-1.aaaaaaaawmpvxvdeydw3nd4jwcrqkgo7cilhx6lqcwl7fgtnsud2ohymrl6q"
}

resource "oci_database_autonomous_database" "tf_adb" {
  compartment_id           = var.compartment_ocid
  cpu_core_count           = var.cpu_core_count
  data_storage_size_in_tbs = var.data_storage_size_in_tbs
  db_name                  = var.db_name
  admin_password           = var.admin_password
  db_version               = var.db_version
  db_workload              = var.db_workload
  display_name             = var.db_name
  is_free_tier             = var.is_free_tier
  license_model            = var.license_model
}


# Outputs
output "db_name" {
  value = oci_database_autonomous_database.tf_adb.display_name
}

output "db_state" {
  value = oci_database_autonomous_database.tf_adb.state
}