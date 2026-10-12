# ============================================================
# CREATE VIRTUAL IPS
# ============================================================
resource "fortios_firewall_vip" "this" {
  for_each = var.vips

  name    = each.key
  comment = each.value.comment
  extip   = each.value.extip
  extintf = each.value.extintf

  # Port forwarding (only when enabled)
  portforward = each.value.portforward ? "enable" : "disable"
  protocol    = each.value.portforward ? each.value.protocol : null
  extport     = each.value.portforward ? each.value.extport : null
  mappedport  = each.value.portforward ? each.value.mappedport : null

  mappedip {
    range = each.value.mappedip
  }
}