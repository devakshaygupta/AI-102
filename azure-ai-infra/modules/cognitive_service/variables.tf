variable "parameters" {
  type        = map
  description = "A map of parameters to be used in the module."
  default     = {}
}

variable "ai_services_sku" {
  type        = string
  description = "The sku name of the Azure Analysis Services server to create."
  default     = "S0"
}

variable "ai_services_kind" {
  type        = string
  description = "The kind of the Azure Analysis Services server to create."
  default     = "CognitiveServices"
}

variable "model_deployment_format" {
  type        = string
  description = "The format of the model to be deployed."
  default     = "OpenAI"
}

variable "model_deployment_sku_name" {
  type        = string
  description = "The sku name for the model deployment."
  default     = "GlobalStandard"
}
