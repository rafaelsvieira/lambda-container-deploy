variable "region" {
  description = "(Optional) Specified the region"
  type        = string
  default     = "us-east-1"
}

variable "ecr_name" {
  description = "(Optional) Specified the ECR name"
  type        = string
  default     = "lambda-container"
}

variable "lambda_name" {
  description = "(Optional) Specified the lambda function name"
  type        = string
  default     = "lambda-container-app"
}

variable "lambda_alias" {
  description = "(Optional) Specified the lambda alias name"
  type        = string
  default     = "stable"
}

variable "deployment_config_name" {
  description = "(Optional) Specified the deployment strategy"
  type        = string
  default     = "CodeDeployDefault.LambdaLinear10PercentEvery1Minute"
  # https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html#deployment-configuration-lambda
}

variable "image_uri" {
  description = "Specified the image URI"
  type        = string
}
