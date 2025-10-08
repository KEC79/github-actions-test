resource "google_storage_bucket" "kc_test_cdn_bucket" {
  name          = "kc-test-2-bucket"
  location      = "EU"
  force_destroy = true
}

resource "google_storage_bucket_object" "kc_test_bucket_folder" {
  name          = "EmptyFolder/"
  content       = " "
  bucket        = "${google_storage_bucket.kc_test_cdn_bucket.name}"
}

# reserve IP address
resource "google_compute_global_address" "kc_test_ip_address" {
  name = "ipaddress"
}

# url map
resource "google_compute_url_map" "kc_test_url_map" {
  name            = "kc-test-http-lb"
  default_service = google_compute_backend_bucket.kc_test_backend_bucket.id
 }

# backend bucket with CDN policy with default ttl settings
resource "google_compute_backend_bucket" "kc_test_backend_bucket" {
  name        = "kc-test-backend-bucket"
  bucket_name = google_storage_bucket.kc_test_cdn_bucket.name
  enable_cdn  = true
  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    client_ttl        = 3600
    default_ttl       = 3600
    max_ttl           = 86400
    negative_caching  = true
    serve_while_stale = 86400
  }
}

resource "google_dns_record_set" "kc_est_dns_record" {
  name         = "static.1.kc-test.example.com."
  type         = "A"
  ttl          = 300
  managed_zone = "kc-test-zone"

  rrdatas = [google_compute_global_address.kc_test_ip_address.address]
}

resource "google_compute_global_forwarding_rule" "kc_test_https_rule" {
  name                  = "kc-test-lb-https-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.kc_test_https_lb_proxy.id
  ip_address            = google_compute_global_address.kc_test_ip_address.address
}

resource "google_compute_target_https_proxy" "kc_test_https_lb_proxy" {
  name            = "kc-test-https-lb-proxy"
  url_map         = google_compute_url_map.kc_test_url_map.id
  certificate_map = "//certificatemanager.googleapis.com/${google_certificate_manager_certificate_map.global_management_cert_certificate_map.id}"
}

resource "google_dns_record_set" "kc_test_cdn_dns_record" {
  name         = "static.1.kc-test.example.com."
  type         = "A"
  ttl          = 300
  managed_zone = "kc-test-zone"

  rrdatas = [google_compute_global_address.kc_test_ip_address.address]
}

