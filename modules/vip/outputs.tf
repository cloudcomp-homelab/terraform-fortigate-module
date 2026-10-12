# ============================================================
# OUTPUTS
# ============================================================
output "vip_names" {
  description = "Names of the created virtual IPs (use as destination in firewall policies)"
  value       = keys(fortios_firewall_vip.this)
}