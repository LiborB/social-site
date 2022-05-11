data "aws_availability_zones" "availability_zones" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "db-vpc"
  cidr                 = "10.0.0.0/16"
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  azs                  = data.aws_availability_zones.availability_zones.names
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = module.vpc.public_subnets
}
