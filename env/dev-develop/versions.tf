terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.3.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.3.0"
    }
  }
}