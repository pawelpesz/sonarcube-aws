data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets  = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i + 100)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1"

  name = "sonarcube-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

module "sonarqube" {
  source              = "cn-terraform/sonarqube/aws"
  version             = "2.0.55"
  name_prefix         = "sonarqube"
  region              = var.region
  vpc_id              = module.vpc.vpc_id
  public_subnets_ids  = module.vpc.public_subnets
  private_subnets_ids = module.vpc.private_subnets
  db_instance_size    = var.db_instance_size
  enable_s3_logs      = false
  enable_ssl          = false
  lb_https_ports      = {}
  lb_http_ports = {
    default = {
      listener_port         = 80
      target_group_port     = 9000
      target_group_protocol = "HTTP"
    }
  }
}
