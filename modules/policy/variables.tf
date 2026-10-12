# ============================================================
# FIREWALL POLICIES
# ============================================================
variable "policies" {
  description = "Firewall policies keyed by name. Address, VIP and service names must already exist on the FortiGate."
  type = map(object({
    srcintf    = list(string)
    dstintf    = list(string)
    srcaddr    = list(string)
    dstaddr    = list(string)
    service    = list(string)
    action     = optional(string, "accept")
    nat        = optional(bool, false)
    schedule   = optional(string, "always")
    logtraffic = optional(string, "all")
    enabled    = optional(bool, true)
    comments   = optional(string, "Managed by Terraform")
  }))
  default = {}

  validation {
    condition     = alltrue([for p in values(var.policies) : contains(["accept", "deny"], p.action)])
    error_message = "action must be accept or deny."
  }

  validation {
    condition     = alltrue([for p in values(var.policies) : contains(["all", "utm", "disable"], p.logtraffic)])
    error_message = "logtraffic must be one of: all, utm, disable."
  }

  # Security guardrail: never allow any-to-any-on-any-service
  validation {
    condition = alltrue([
      for p in values(var.policies) :
      !(p.action == "accept" && contains(p.srcaddr, "all") && contains(p.dstaddr, "all") && contains(p.service, "ALL"))
    ])
    error_message = "Policies that accept all sources to all destinations on service ALL are not allowed."
  }
}