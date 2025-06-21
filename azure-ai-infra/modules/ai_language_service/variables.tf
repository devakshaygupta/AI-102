variable "parameters" {
  type        = map(any)
  description = "A map of parameters to be used in the module."
  default     = {}
}

variable "language_services_sku" {
  type        = string
  description = "The sku name of the Azure Language Services server to create."
  default     = "S"
}

variable "deployment_sku_name" {
  type        = string
  description = "The sku name for the model deployment."
  default     = "Standard"
}
