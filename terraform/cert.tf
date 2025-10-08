# # DNS authorization for the zone domain
# resource "google_certificate_manager_dns_authorization" "global_dns_auth" {
#   name     = "global-dns-auth"
#   domain   = "kc-test.example.com"
#   location = "global"
# }

# # DNS record for ACME challenge (required for certificate validation)
# resource "google_dns_record_set" "global_challenge" {
#   name         = google_certificate_manager_dns_authorization.global_dns_auth.dns_resource_record[0].name
#   type         = google_certificate_manager_dns_authorization.global_dns_auth.dns_resource_record[0].type
#   ttl          = 300
#   managed_zone = "kc-test-zone"

#   rrdatas = [google_certificate_manager_dns_authorization.global_dns_auth.dns_resource_record[0].data]
# }

# # Global Google-managed certificate using Certificate Manager
# resource "google_certificate_manager_certificate" "global_management_cert" {
#   name        = "global-management-cert"
#   location    = "global"

#   managed {
#     domains = [
#       google_certificate_manager_dns_authorization.global_dns_auth.domain,
#       "*.${google_certificate_manager_dns_authorization.global_dns_auth.domain}"
#     ]
#     dns_authorizations = [
#       google_certificate_manager_dns_authorization.global_dns_auth.id
#     ]
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Certificate map to hold the certificate
# resource "google_certificate_manager_certificate_map" "global_management_cert_certificate_map" {
#   name = "global-management-cert-map"
# }

# # Certificate map entry to associate the certificate with the map
# resource "google_certificate_manager_certificate_map_entry" "global_management_cert_map_entry" {
#   name         = "global-management-cert-map-entry"
#   map          = google_certificate_manager_certificate_map.global_management_cert_certificate_map.name
#   hostname     = "static.kc-test.example.com"
#   certificates = [google_certificate_manager_certificate.global_management_cert.id]
# }
