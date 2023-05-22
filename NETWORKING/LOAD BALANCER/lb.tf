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
}


data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1	
}


/* Load Balancer */

resource "oci_load_balancer" "lb1" {
  shape          = "100Mbps"
  compartment_id = var.compartment_ocid

  subnet_ids = [
    var.subnet_id
  ]

  display_name = "dmone-lb"


}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = oci_load_balancer.lb1.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}


resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = oci_load_balancer.lb1.id
  name                     = "dmone-lsnr"
  default_backend_set_name = oci_load_balancer_backend_set.lb-bes1.name
  port                     = 80
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_listener" "lb-listener2" {
  load_balancer_id         = oci_load_balancer.lb1.id
  name                     = "https-lsnr"
  default_backend_set_name = oci_load_balancer_backend_set.lb-bes1.name
  port                     = 443
  protocol                 = "HTTP"

  ssl_configuration {
    certificate_ids                    = var.certificate_ids
    # trusted_certificate_authority_ids  = var.trusted_certificate_authority_ids
    verify_peer_certificate            = false
    protocols                          = ["TLSv1.1", "TLSv1.2"]
    server_order_preference            = "ENABLED"
    cipher_suite_name                  = oci_load_balancer_ssl_cipher_suite.test_ssl_cipher_suite.name
  }
}

resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = oci_load_balancer.lb1.id
  backendset_name  = oci_load_balancer_backend_set.lb-bes1.name
  ip_address       = var.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}



output "lb_public_ip" {
  value = [oci_load_balancer.lb1.ip_address_details]
}

resource "oci_load_balancer_ssl_cipher_suite" "test_ssl_cipher_suite" {
  #Required
  name = "test_cipher_name"

  ciphers = ["AES128-SHA", "AES256-SHA"]

  #Optional
  load_balancer_id = oci_load_balancer.lb1.id
}

data "oci_load_balancer_ssl_cipher_suites" "test_ssl_cipher_suites" {
  #Optional
  load_balancer_id = oci_load_balancer.lb1.id
}