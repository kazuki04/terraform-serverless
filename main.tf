terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "iam" {
  source                 = "./modules/iam"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier

  ddb_table_arn = module.dynamodb.table_arn
}

module "cognito" {
  source                 = "./modules/cognito"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier
}

module "dynamodb" {
  source = "./modules/dynamodb"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier

  ddb_hash_key   = var.ddb_hash_key
  ddb_attributes = var.ddb_attributes
}
