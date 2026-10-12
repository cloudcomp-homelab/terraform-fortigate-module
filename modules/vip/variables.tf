# ============================================================
# VIRTUAL IPS (DNAT / PORT FORWARDS)
# ============================================================
variable "vips" {
  description = "Virtual IPs keyed by name. With portforward = true, extport and mappedport are required."
  type = map(object({
    extip       = string
    extintf     = string
    mappedip    = string
    portforward = optional(bool, false)
    protocol    = optional(string, "tcp")
    extport     = optional(string)
    mappedport  = optional(string)
    comment     = optional(string, "Managed by Terraform")
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.vips) : contains(["tcp", "udp", "sctp"], v.protocol)])
    error_message = "protocol must be one of: tcp, udp, sctp."
  }

  validation {
    condition     = alltrue([for v in values(var.vips) : !v.portforward || (v.extport != null && v.mappedport != null)])
    error_message = "VIPs with portforward = true need both extport and mappedport."
  }

  validation {
    condition     = alltrue([for v in values(var.vips) : can(cidrhost("${v.mappedip}/32", 0))])
    error_message = "mappedip must be a single valid IPv4 address, e.g. 10.0.0.10."
  }
}