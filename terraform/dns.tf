provider "google" {
  project     = "crypto-galaxy-246113"
  region      = "us-central1"
}

##===================================================
## Zones
##===================================================
resource "google_dns_managed_zone" "brittg_com" {
  name         = "dns01"
  dns_name     = "brittg.com."

  dnssec_config {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "off"

    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 2048
      key_type   = "keySigning"
      kind       = "dns#dnsKeySpec"
    }
    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 1024
      key_type   = "zoneSigning"
      kind       = "dns#dnsKeySpec"
    }
  }
}

resource "google_dns_managed_zone" "demophoon_com" {
  name         = "dns02"
  dns_name     = "demophoon.com."

  dnssec_config {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "off"

    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 2048
      key_type   = "keySigning"
      kind       = "dns#dnsKeySpec"
    }
    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 1024
      key_type   = "zoneSigning"
      kind       = "dns#dnsKeySpec"
    }
  }
}

resource "google_dns_managed_zone" "ddbbb_party" {
  name         = "ddbbb"
  dns_name     = "ddbbb.party."
}

resource "google_dns_managed_zone" "tamagotchi_rodeo" {
  name         = "dns03"
  dns_name     = "tamagotchi.rodeo."
}

##===================================================
## Records
##===================================================
resource "google_dns_record_set" "main" {
  name         = "brittg.com."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.brittg_com.name

  rrdatas = [digitalocean_loadbalancer.public.ip]
  #rrdatas = [ for vm in module.vm-do : vm.ip ]
}

resource "google_dns_record_set" "compute-lb" {
  name         = "compute-lb.demophoon.com."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.demophoon_com.name

  rrdatas = [digitalocean_loadbalancer.public.ip]
  #rrdatas = [ for vm in module.vm-do : vm.ip ]
}

## Valheim
##---------------------------------------------------
resource "google_dns_record_set" "valheim" {
  name         = "valheim.demophoon.com."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.demophoon_com.name

  rrdatas = ["compute-lb.demophoon.com."]
}

resource "google_dns_record_set" "valheim-brittg" {
  name         = "valheim.brittg.com."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.brittg_com.name

  rrdatas = ["compute-lb.demophoon.com."]
}


## tamagotchi ses email
##---------------------------------------------------
resource "google_dns_record_set" "tamagotchi_rodeo_ses" {
  name         = "_amazonses.tamagotchi.rodeo."
  type         = "TXT"
  ttl          = 300
  managed_zone = google_dns_managed_zone.tamagotchi_rodeo.name

  rrdatas = ["Ybm0OBO3ll2Ph/cZAIw5n6B6YWMON5CR5jGj7xXqotE="]
}
resource "google_dns_record_set" "tamagotchi_rodeo_dkim" {
  name         = "tamagotchi.rodeo."
  type         = "TXT"
  ttl          = 300
  managed_zone = google_dns_managed_zone.tamagotchi_rodeo.name

  rrdatas = ["amazonses:Ybm0OBO3ll2Ph/cZAIw5n6B6YWMON5CR5jGj7xXqotE="]
}
resource "google_dns_record_set" "tamagotchi_rodeo_email" {
  name         = "5weg64v2hr7n53a6xzwecaiv24aa55dw._domainkey.tamagotchi.rodeo."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.tamagotchi_rodeo.name

  rrdatas = ["5weg64v2hr7n53a6xzwecaiv24aa55dw.dkim.amazonses.com."]
}
resource "google_dns_record_set" "tamagotchi_rodeo_email_2" {
  name         = "cx6pnleg4qci3wwgkdgxmbxw5n5gvybi._domainkey.tamagotchi.rodeo."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.tamagotchi_rodeo.name

  rrdatas = ["cx6pnleg4qci3wwgkdgxmbxw5n5gvybi.dkim.amazonses.com."]
}
resource "google_dns_record_set" "tamagotchi_rodeo_email_3" {
  name         = "4ocgj5rvz2ouskpaz442cmshkauyo3wq._domainkey.tamagotchi.rodeo."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.tamagotchi_rodeo.name

  rrdatas = ["4ocgj5rvz2ouskpaz442cmshkauyo3wq.dkim.amazonses.com."]
}
