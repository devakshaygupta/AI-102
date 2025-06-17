variable "key_vault_name_prefix" {
  type        = string
  description = "Prefix of the key vault name."
  default     = "kv"
}

variable "parameters" {
  type        = map(any)
  description = "A map of parameters to be used in the module."
  default     = {}
}
