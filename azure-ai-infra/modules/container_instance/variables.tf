variable "create_container_group" {
  type        = bool
  description = "Flag to create the container group. Set to false if you want to skip creating the container group."
  default     = false
}

variable "container_group_name_prefix" {
  type        = string
  description = "Prefix of the container group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "container-group"
}

variable "container_image" {
  type        = string
  description = "The container image for the AI services."
  default     = "mcr.microsoft.com/azure-cognitive-services/textanalytics/sentiment:latest"
}

variable "container_ip_address_type" {
  type        = string
  description = "The IP address type for the container group."
  default     = "Public"
}

variable "container_name_prefix" {
  type        = string
  description = "Prefix of the container group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "container"
}

variable "container_os_type" {
  type        = string
  description = "The OS type of the container."
  default     = "Linux"
}

variable "container_group_sku" {
  type        = string
  description = "The SKU for the container group."
  default     = "Standard"
}

variable "container_restart_policy" {
  type        = string
  description = "The restart policy for the container group."
  default     = "OnFailure"
}

variable "container_port" {
  type        = number
  description = "The port on which the container listens."
  default     = 5000
}

variable "number_of_cpus" {
  type        = string
  description = "The number of CPUs for the container."
  default     = "1"
}

variable "size_of_ram" {
  type        = string
  description = "The amount of RAM for the container in GB."
  default     = "1"
}
