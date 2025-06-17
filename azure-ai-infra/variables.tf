variable "resource_group_location" {
  type        = string
  description = "Location for all resources."
  default     = "swedencentral"
}

variable "ai_services_kind" {
  type        = string
  description = "The kind of the AI services to create."
  default     = "AIServices"
}

variable "ai_search_required" {
  type        = bool
  description = "Flag to indicate if AI Search Service is required."
  default     = false
}
