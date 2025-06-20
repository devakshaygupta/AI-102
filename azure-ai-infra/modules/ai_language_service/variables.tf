variable "parameters" {
  type        = map(any)
  description = "A map of parameters to be used in the module."
  default     = {}
}

variable "ai_services_sku" {
  type        = string
  description = "The sku name of the Azure Analysis Services server to create."
  default     = "F0"
}

variable "deployment_sku_name" {
  type        = string
  description = "The sku name for the model deployment."
  default     = "Standard"
}
