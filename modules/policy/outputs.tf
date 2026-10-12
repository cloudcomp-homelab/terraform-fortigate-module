# ============================================================
# OUTPUTS
# ============================================================
output "policy_ids" {
  description = "Policy IDs assigned by the FortiGate, keyed by policy name"
  value       = { for k, p in fortios_firewall_policy.this : k => p.policyid }
}