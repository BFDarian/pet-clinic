variable "access_key" {
  type      = string
  sensitive = true
}
variable "secret_key" {
  type = string
  sensitive = true
}
variable "db_password" { # TF_VAR_db_password
  type = string
  sensitive = true
}