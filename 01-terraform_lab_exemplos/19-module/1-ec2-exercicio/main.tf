provider "aws" {
  region = "sa-east-1"
}

module "criar_vpc" {
  source = "./VPC"
}

module "criar_instancia" {
  source = "./instancia"
  subnet_ids = module.criar_vpc.subnet_id
}
