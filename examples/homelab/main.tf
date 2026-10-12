# ============================================================
# ADDRESS OBJECTS & GROUPS
# ============================================================
module "address" {
  source = "../../modules/address"

  addresses = {
    "h-web01" = {
      cidr    = "10.0.10.20/32"
      comment = "Web server in DMZ"
    }
    "n-lan" = {
      cidr    = "10.0.1.0/24"
      comment = "Internal client network"
    }
    "r-dhcp-pool" = {
      type     = "iprange"
      start_ip = "10.0.1.100"
      end_ip   = "10.0.1.200"
      comment  = "DHCP pool"
    }
    "f-updates" = {
      type    = "fqdn"
      fqdn    = "updates.example.com"
      comment = "Update server"
    }
  }

  address_groups = {
    "grp-dmz-servers" = {
      members = ["h-web01"]
    }
  }
}

# ============================================================
# VIRTUAL IPS
# ============================================================
module "vip" {
  source = "../../modules/vip"

  vips = {
    "vip-web01-https" = {
      extip       = "203.0.113.10"
      extintf     = "wan1"
      mappedip    = "10.0.10.20"
      portforward = true
      protocol    = "tcp"
      extport     = "443"
      mappedport  = "443"
      comment     = "Publish web server over HTTPS"
    }
  }
}

# ============================================================
# FIREWALL POLICIES
# ============================================================
module "policy" {
  source = "../../modules/policy"

  policies = {
    "wan-to-dmz-web-https" = {
      srcintf  = ["wan1"]
      dstintf  = ["dmz"]
      srcaddr  = ["all"]
      dstaddr  = ["vip-web01-https"]
      service  = ["HTTPS"]
      comments = "Allow HTTPS from internet to web server"
    }
    "lan-to-wan-web" = {
      srcintf  = ["internal"]
      dstintf  = ["wan1"]
      srcaddr  = ["n-lan"]
      dstaddr  = ["all"]
      service  = ["HTTP", "HTTPS", "DNS"]
      nat      = true
      comments = "Allow internet browsing from LAN"
    }
  }

  # Policies reference objects created by the other modules
  depends_on = [module.address, module.vip]
}