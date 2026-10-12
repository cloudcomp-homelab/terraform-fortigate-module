# ============================================================
# OUTPUTS
# ============================================================
output "address_names" {
  description = "Names of the created address objects"
  value       = keys(fortios_firewall_address.this)
}

output "address_group_names" {
  description = "Names of the created address groups"
  value       = keys(fortios_firewall_addrgrp.this)
}