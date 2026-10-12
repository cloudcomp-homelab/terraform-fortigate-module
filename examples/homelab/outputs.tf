# ============================================================
# OUTPUTS
# ============================================================
output "addresses" {
  value = module.address.address_names
}

output "vips" {
  value = module.vip.vip_names
}

output "policy_ids" {
  value = module.policy.policy_ids
}