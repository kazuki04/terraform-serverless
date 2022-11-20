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
  source                 = "./modules/dynamodb"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier

  ddb_hash_key   = var.ddb_hash_key
  ddb_attributes = var.ddb_attributes
}

module "lambda" {
  source                 = "./modules/lambda"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier

  role_arn_lambda = module.iam.role_arn_lambda
}

module "apigateway" {
  source                 = "./modules/apigateway"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier

  cognito_user_pool_endpoint  = module.cognito.cognito_user_pool_endpoint
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  lambda_functio_arn          = module.lambda.functio_arn
}
