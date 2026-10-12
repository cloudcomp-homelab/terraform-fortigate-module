# ============================================================
# CREATE FIREWALL POLICIES
# ============================================================
resource "fortios_firewall_policy" "this" {
  for_each = var.policies

  name       = each.key
  action     = each.value.action
  schedule   = each.value.schedule
  logtraffic = each.value.logtraffic
  nat        = each.value.nat ? "enable" : "disable"
  status     = each.value.enabled ? "enable" : "disable"
  comments   = each.value.comments

  dynamic "srcintf" {
    for_each = each.value.srcintf
    content {
      name = srcintf.value
    }
  }

  dynamic "dstintf" {
    for_each = each.value.dstintf
    content {
      name = dstintf.value
    }
  }

  dynamic "srcaddr" {
    for_each = each.value.srcaddr
    content {
      name = srcaddr.value
    }
  }

  dynamic "dstaddr" {
    for_each = each.value.dstaddr
    content {
      name = dstaddr.value
    }
  }

  dynamic "service" {
    for_each = each.value.service
    content {
      name = service.value
    }
  }
}