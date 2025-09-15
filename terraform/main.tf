terraform {
  required_version = ">= 1.12.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "gha-terraform-state"
    prefix = "test/terraform.tfstate"
  }
}

provider "google" {
  project = "test-iam-471818"
  region  = "europe-west2"
}
