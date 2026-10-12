# terraform-fortigate-module

[![ci](https://github.com/cloudcomp-homelab/terraform-fortigate-module/actions/workflows/ci.yml/badge.svg)](https://github.com/cloudcomp-homelab/terraform-fortigate-module/actions/workflows/ci.yml)

Reusable Terraform modules to manage **FortiGate** firewall configuration as code: address objects, virtual IPs and firewall policies.

## Modules

| Module | Manages | Key features |
|---|---|---|
| [`modules/address`](modules/address) | Address objects and address groups | `ipmask` (CIDR input), `iprange`, `fqdn`; input validation |
| [`modules/vip`](modules/vip) | Virtual IPs (DNAT / port forwards) | Optional port forwarding; validated protocol, ports and mapped IP |
| [`modules/policy`](modules/policy) | Firewall policies | Multiple interfaces/addresses/services; logging enabled by default; **guardrail that blocks any-to-any-on-any-service accept rules** |

## Usage

```hcl
module "address" {
  source = "github.com/cloudcomp-homelab/terraform-fortigate-module//modules/address"

  addresses = {
    "h-web01" = { cidr = "10.0.10.20/32", comment = "Web server in DMZ" }
  }
}
```

A complete example (address objects, a VIP and two policies) is in [`examples/homelab`](examples/homelab).

## Authentication

Connection details are never stored in code. The FortiOS provider reads them from environment variables:

| Variable | Value |
|---|---|
| `FORTIOS_ACCESS_HOSTNAME` | FortiGate IP address or FQDN |
| `FORTIOS_ACCESS_TOKEN` | REST API admin token |

## Naming convention

| Prefix | Object type |
|---|---|
| `h-` | Host |
| `n-` | Network |
| `r-` | IP range |
| `f-` | FQDN |
| `grp-` | Address group |
| `vip-` | Virtual IP |

## CI

Every pull request runs:

- `terraform fmt` and `terraform validate` for all modules and the example
- **TFLint** (recommended ruleset)
- **Gitleaks** secret scan of the full Git history, with results published to GitHub Code scanning

The CI has no connection to a real FortiGate. All values in this repository are examples (`10.0.x.x`, `example.com` and the documentation range `203.0.113.0/24`).

## Requirements

| Name | Version |
|---|---|
| Terraform | >= 1.9.0 |
| [fortinetdev/fortios](https://registry.terraform.io/providers/fortinetdev/fortios) | ~> 1.0 |

## License

[MIT](LICENSE)