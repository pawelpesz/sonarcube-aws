terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket     = "sonarqube-terraform-state-20230720143534798300000001"
    key        = "backend/terraform.tfstate"
    region     = "eu-north-1"
    encrypt    = true
    kms_key_id = "ef200bee-3ac7-476b-a6f4-a34e11d6a5d1"
  }
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "replica"
  region = var.region
}

module "remote_state" {
  source                           = "nozaq/remote-state-s3-backend/aws"
  version                          = "1.5.0"
  enable_replication               = false
  state_bucket_prefix              = "sonarqube-terraform-state-"
  dynamodb_table_name              = "sonarqube-terraform-state-lock"
  kms_key_alias                    = "sonarqube-terraform-state-key"
  terraform_iam_policy_name_prefix = "sonarqube-terraform-"
  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}

output "configuration" {
  description = "Backend configuration"
  value = {
    bucket         = module.remote_state.state_bucket.bucket
    key            = "sonarqube/terraform.tfstate"
    region         = var.region
    encrypt        = true
    kms_key_id     = module.remote_state.kms_key.id
    dynamodb_table = module.remote_state.dynamodb_table.id
  }
}
