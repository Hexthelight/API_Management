variable "tags" {
  description = "Default tags"
  type        = map(string)
  default = {
    project   = "002-API_Gateway"
    temporary = "true"
  }
}