variable "basename" {
  description = "The basename/prefix with which all WiFi networks names start."
  type        = string
}

variable "username" {
  description = "After the docs: 'Local user name for the Unifi controller API. Can be specified with the UNIFI_USERNAME environment variable.'"
  type        = string
  default     = null
}
variable "password" {
  description = "After the docs: 'Password for the user accessing the API. Can be specified with the UNIFI_PASSWORD environment variable.'"
  type        = string
  default     = null
}

variable "api_url" {
  description = "After the docs: 'URL of the controller API. Can be specified with the UNIFI_API environment variable. You should NOT supply the path (/api), the SDK will discover the appropriate paths. This is to support UDM Pro style API paths as well as more standard controller paths.'"
  type        = string
  default     = "https://192.168.1.1:8443/"
}

variable "networks" {
  description = "A map of networks and their passwords. Can't exceed 3 since the UDM's limit for WiFi networks is 4."
  type        = map(string)

  validation {
    condition = (
      length(var.networks) < 4
    )
    error_message = "The map of networks must have no more than 3 keys!"
  }
}
