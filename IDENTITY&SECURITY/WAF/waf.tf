terraform {
    required_providers {
      oci = {
        source = "oracle/oci"
      }
    }
  }

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  region = var.region
}

resource "oci_waf_web_app_firewall_policy" "test_waf_web_app_firewall_policy" {
  #Required
  compartment_id = var.compartment_ocid

  # Optional
  display_name = var.waf_policy_display_name

  actions {
    #Required
    name = "defaultAction"
    type = "ALLOW"
  }

  actions {
    #Required
    name = "return401Response"
    type = "RETURN_HTTP_RESPONSE"
    code = 401
    body {
      #Required
      type = "STATIC_TEXT"
      text = "{\n\"code\": 401,\n\"message\":\"Unauthorised\"\n}"
    }

    #Optional
    headers {
      #Required
      name = "Header1"
      value = "Value1"
    }

  }

  request_access_control {
    #Required
    default_action_name = "defaultAction"
    #Optional
    rules {
      #Required
      type = "ACCESS_CONTROL"
      name = "requestAccessRule"
      action_name = "return401Response"
      condition = "i_contains(keys(http.request.headers), 'Header1')"
      #Optional
      condition_language = "JMESPATH"
    }
  }

  request_protection {
    #Optional
    body_inspection_size_limit_exceeded_action_name = "return401Response"
    body_inspection_size_limit_in_bytes = 8192
    rules {
      #Required
      type = "PROTECTION"
      name = "requestProtectionRule"
      action_name = "return401Response"
      is_body_inspection_enabled = true
      protection_capabilities {
        #Required
        key = "9300000"
        version = 1
        #Optional
        collaborative_action_threshold = 4
        collaborative_weights {
          key = "9301000"
          weight = 2
        }
        collaborative_weights {
          key = "9301100"
          weight = 2
        }
        collaborative_weights {
          key = "9301200"
          weight = 2
        }
        collaborative_weights {
          key = "9301300"
          weight = 2
        }
        exclusions {
          args = ["argName1", "argName2"]
          request_cookies = ["cookieName1", "cookieName2"]
        }
      }
    }
  }

  request_rate_limiting {
    #Optional
    rules {
      #Required
      type = "REQUEST_RATE_LIMITING"
      name = "requestRateLimitingRule"
      action_name = "return401Response"
      configurations {
        #Required
        period_in_seconds = 100
        requests_limit = 10
        #Optional
        action_duration_in_seconds = 10
      }
      #Optional
      condition = "i_contains(keys(http.request.headers), 'Header1')"
      condition_language = "JMESPATH"
    }
  }

  response_access_control {
    #Optional
    rules {
      #Required
      type = "ACCESS_CONTROL"
      name = "responseAccessRule"
      action_name = "return401Response"
      condition = "i_contains(keys(http.response.headers), 'Header1')"
      #Optional
      condition_language = "JMESPATH"
    }
  }

  freeform_tags = {
    "Department" = "Finance"
  }
}

resource "oci_waf_web_app_firewall" "test_waf_web_app_firewall" {
  #Required
  compartment_id = var.compartment_ocid
  backend_type = "LOAD_BALANCER"
  load_balancer_id = var.load_balancer_ocid
  web_app_firewall_policy_id = oci_waf_web_app_firewall_policy.test_waf_web_app_firewall_policy.id

  #Optional
  display_name = var.waf_web_app_firewall

  freeform_tags = {
    "Department" = "Finance"
  }
}
