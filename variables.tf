variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default     = "b1g73ga4p1hchrvctbgo"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gcms0oj5ro6jjsgqdg"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}



