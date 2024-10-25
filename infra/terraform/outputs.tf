output "codedeploy_app_name" {
  description = "Name of CodeDeploy application"
  value       = module.deploy.codedeploy_app_name
}

output "lambda_alias_name" {
  description = "Lambda alias name"
  value       = module.lambda_alias.lambda_alias_name
}

output "lambda_function_name" {
  description = "lambda function name"
  value       = module.lambda_function.lambda_function_name
}
