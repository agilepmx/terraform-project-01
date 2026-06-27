project_name = "agile"
environment = "dev"
vpc_cidr = "10.16.0.0/16"
vpc_name = "vpc-01"


subnets_data = {
    "sn-reserved-A" = { public = false, cidr = "10.16.0.0/20", az = "us-east-1a", ipv6_offset = "00" }
    "sn-db-A"       = { public = false, cidr = "10.16.16.0/20", az = "us-east-1a", ipv6_offset = "01" }
    "sn-app-A"      = { public = false, cidr = "10.16.32.0/20", az = "us-east-1a", ipv6_offset = "02" }
    "sn-web-A"      = { public = true, cidr = "10.16.48.0/20", az = "us-east-1a", ipv6_offset = "03" }

    "sn-reserved-B" = { public = false, cidr = "10.16.64.0/20", az = "us-east-1b", ipv6_offset = "04" }
    "sn-db-B"       = { public = false, cidr = "10.16.80.0/20", az = "us-east-1b", ipv6_offset = "05" }
    "sn-app-B"      = { public = false, cidr = "10.16.96.0/20", az = "us-east-1b", ipv6_offset = "06" }
    "sn-web-B"      = { public = true, cidr = "10.16.112.0/20", az = "us-east-1b", ipv6_offset = "07" }

    "sn-reserved-C" = {public = false, cidr = "10.16.128.0/20", az = "us-east-1c", ipv6_offset = "08" }
    "sn-db-C"       = { public = false, cidr = "10.16.144.0/20", az = "us-east-1c", ipv6_offset = "09" }
    "sn-app-C"      = { public = false, cidr = "10.16.160.0/20", az = "us-east-1c", ipv6_offset = "0A" }
    "sn-web-C"      = { public = true, cidr = "10.16.176.0/20", az = "us-east-1c", ipv6_offset = "0B" }
  }