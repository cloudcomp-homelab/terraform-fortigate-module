# ============================================================
# ADDRESS OBJECTS
# ============================================================
variable "addresses" {
  description = "Address objects keyed by name. type: ipmask (cidr), iprange (start_ip/end_ip) or fqdn (fqdn)."
  type = map(object({
    type     = optional(string, "ipmask")
    cidr     = optional(string)
    start_ip = optional(string)
    end_ip   = optional(string)
    fqdn     = optional(string)
    comment  = optional(string, "Managed by Terraform")
  }))
  default = {}

  validation {
    condition     = alltrue([for a in values(var.addresses) : contains(["ipmask", "iprange", "fqdn"], a.type)])
    error_message = "type must be one of: ipmask, iprange, fqdn."
  }

  validation {
    condition     = alltrue([for a in values(var.addresses) : a.type != "ipmask" || can(cidrnetmask(a.cidr))])
    error_message = "Addresses of type ipmask need a valid cidr, e.g. 10.0.0.10/32."
  }
}

# ============================================================
# ADDRESS GROUPS
# ============================================================
variable "address_groups" {
  description = "Address groups keyed by name. members must be names of address objects."
  type = map(object({
    members = list(string)
    comment = optional(string, "Managed by Terraform")
  }))
  default = {}
}