variable "resource_group_location" {
  type        = string
  description = "Location for all resources."
  default     = "eastus2"
}

variable "ai_services_kind" {
  type        = string
  description = "The kind of the AI services to create."
  default     = "OpenAI"
}
