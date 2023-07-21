terraform {
  backend "s3" {
    bucket         = "sonarqube-terraform-state-20230720143534798300000001"
    key            = "sonarqube/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "sonarqube-terraform-state-lock"
    kms_key_id     = "ef200bee-3ac7-476b-a6f4-a34e11d6a5d1"
  }
}
