variable "project" {
  type    = string
  default = "web-dev-tac"
}

variable "credentials_file" {
  type    = string
  default = "./web-dev-tac-service-account.json"
}

variable "region" {
  type    = string
  default = "northamerica-northeast1"
}

variable "zone" {
  type    = string
  default = "northamerica-northeast1-a"

}
