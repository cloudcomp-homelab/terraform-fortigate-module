# ============================================================
# CREATE ADDRESS OBJECTS
# ============================================================
resource "fortios_firewall_address" "this" {
  for_each = var.addresses

  name    = each.key
  type    = each.value.type
  comment = each.value.comment

  # ipmask: convert CIDR to "ip netmask" (FortiOS format)
  subnet = each.value.type == "ipmask" ? "${cidrhost(each.value.cidr, 0)} ${cidrnetmask(each.value.cidr)}" : null

  # iprange
  start_ip = each.value.type == "iprange" ? each.value.start_ip : null
  end_ip   = each.value.type == "iprange" ? each.value.end_ip : null

  # fqdn
  fqdn = each.value.type == "fqdn" ? each.value.fqdn : null
}

# ============================================================
# CREATE ADDRESS GROUPS
# ============================================================
resource "fortios_firewall_addrgrp" "this" {
  for_each = var.address_groups

  name    = each.key
  comment = each.value.comment

  dynamic "member" {
    for_each = each.value.members
    content {
      name = member.value
    }
  }

  depends_on = [fortios_firewall_address.this]
}