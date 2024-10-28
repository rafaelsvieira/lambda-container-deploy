##############################################
# ECR
##############################################

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.3.0"

  repository_name         = var.ecr_name
  repository_force_delete = true

  create_lifecycle_policy = true

  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}

##############################################
# Lambda
##############################################

locals {
  image_uri_parsed = split(":", var.image_uri)
  app_version      = element(local.image_uri_parsed, length(local.image_uri_parsed) - 1)
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.14.0"

  function_name = var.lambda_name
  description   = "Version ${local.app_version}"
  publish       = true
  #   create_package = false
  image_uri     = var.image_uri
  package_type  = "Image"
  architectures = ["x86_64"]

  environment_variables = {
    APP_VERSION = local.app_version
  }

  tags = {
    Name = var.lambda_name
  }

  depends_on = [
    module.ecr
  ]
}

module "lambda_alias" {
  source  = "terraform-aws-modules/lambda/aws//modules/alias"
  version = "~> 7.14.0"

  name          = var.lambda_alias
  function_name = module.lambda_function.lambda_function_name
  #   function_version = module.lambda_function.lambda_function_version
  refresh_alias = false

  depends_on = [
    module.lambda_function
  ]
}

##############################################
# CodeDeploy
##############################################

module "deploy" {
  source  = "terraform-aws-modules/lambda/aws//modules/deploy"
  version = "~> 7.14.0"

  alias_name    = module.lambda_alias.lambda_alias_name
  function_name = module.lambda_function.lambda_function_name

  target_version = module.lambda_function.lambda_function_version

  create_app = true
  app_name   = module.lambda_function.lambda_function_name

  create_deployment_group = true
  deployment_group_name   = "${module.lambda_function.lambda_function_name}-${module.lambda_alias.lambda_alias_name}"
  deployment_config_name  = var.deployment_config_name

  create_deployment = true
  run_deployment    = true
  #   wait_deployment_completion = true
  depends_on = [
    module.lambda_function,
    module.lambda_alias
  ]
}
