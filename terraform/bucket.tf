resource "google_storage_bucket" "no-public-access" {
  name          = "gha-demo-bucket"
  location      = "EU"
  force_destroy = true

  public_access_prevention = "enforced"
}