subnets_data = {
    "sn-reserved-A" = { subnet_type = "reserved", cidr = "10.16.0.0/20", az = "us-east-1a", ipv6_offset = "00" }
    "sn-db-A"       = { subnet_type = "db", cidr = "10.16.16.0/20", az = "us-east-1a", ipv6_offset = "01" }
    "sn-app-A"      = { subnet_type = "app", cidr = "10.16.32.0/20", az = "us-east-1a", ipv6_offset = "02" }
    "sn-web-A"      = { subnet_type = "web", cidr = "10.16.48.0/20", az = "us-east-1a", ipv6_offset = "03" }

    "sn-reserved-B" = { subnet_type = "reserved", cidr = "10.16.64.0/20", az = "us-east-1b", ipv6_offset = "04" }
    "sn-db-B"       = { subnet_type = "db", cidr = "10.16.80.0/20", az = "us-east-1b", ipv6_offset = "05" }
    "sn-app-B"      = { subnet_type = "app", cidr = "10.16.96.0/20", az = "us-east-1b", ipv6_offset = "06" }
    "sn-web-B"      = { subnet_type = "web", cidr = "10.16.112.0/20", az = "us-east-1b", ipv6_offset = "07" }

    "sn-reserved-C" = {subnet_type = "reserved", cidr = "10.16.128.0/20", az = "us-east-1c", ipv6_offset = "08" }
    "sn-db-C"       = { subnet_type = "db", cidr = "10.16.144.0/20", az = "us-east-1c", ipv6_offset = "09" }
    "sn-app-C"      = { subnet_type = "app", cidr = "10.16.160.0/20", az = "us-east-1c", ipv6_offset = "0A" }
    "sn-web-C"      = { subnet_type = "web", cidr = "10.16.176.0/20", az = "us-east-1c", ipv6_offset = "0B" }
  }