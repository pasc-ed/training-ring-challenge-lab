terraform {
  backend "s3" {
    bucket         = "ta-pascal-project-states-686520628199"
    key            = "challenge/ring-challenge/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}