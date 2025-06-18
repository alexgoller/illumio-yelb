variable "pce_url" {
  description = "The PCE host URL, standard http(s) notation with optional port https://pce.example.com:8443"
  type        = string
}

variable "pce_org_id" {
  description = "The PCE organization ID"
  type        = string
  default     = 1
}

variable "pce_api_key" {
  description = "The PCE API user"
  type        = string
}

variable "pce_api_secret" {
  description = "The PCE API secret"
  type        = string
}
