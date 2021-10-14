provider "aws" {
  region = "sa-east-1"
}

module "criar_vpc" {
  source = "./VPC"
  #nome = "deploy"
}

module "criar_instancia" {
  source = "./instancia"
  nome = "deploy"
}
