data "cloudflare_zone" "homelab" {
  name = var.homelab_domain
}

resource "cloudflare_record" "headscale" {
  zone_id = data.cloudflare_zone.homelab.id
  name    = "headscale"
  value   = oci_core_instance.headscale.public_ip
  type    = "A"
  ttl     = 3600
}
