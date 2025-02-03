# This file includes details related to backend where terraform state will  be stored.
# This is being done manage the lock and helps team collaborate .

terraform {
 backend "gcs" {
   #credentials = "web-dev-tac-service-account.json"
   bucket      = "tf-back"
   prefix      = "env/dev"
 }
}
