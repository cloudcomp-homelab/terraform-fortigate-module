# ============================================================
# TERRAFORM & PROVIDER REQUIREMENTS
# ============================================================
terraform {
  required_version = ">= 1.9.0"

  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
      version = "~> 1.0"
    }
  }
}