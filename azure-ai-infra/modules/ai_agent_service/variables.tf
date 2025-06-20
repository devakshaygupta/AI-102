variable "parameters" {
  type        = map(any)
  description = "A map of parameters to be used in the module."
  default     = {}
}

variable "location" {
  type        = string
  description = "The location for the AI services."
  default     = "eastus2"
}

variable "ai_services_sku" {
  type        = string
  description = "The sku name of the Azure Analysis Services server to create."
  default     = "S0"
}

variable "deployment_format" {
  type        = string
  description = "The format of the model to be deployed."
  default     = "OpenAI"
}

variable "deployment_model_name" {
  type        = string
  description = "The name of the model to be deployed."
  default     = "gpt-4o"
}

variable "deployment_sku_name" {
  type        = string
  description = "The sku name for the model deployment."
  default     = "Standard"
}
