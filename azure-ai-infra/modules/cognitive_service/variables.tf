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
