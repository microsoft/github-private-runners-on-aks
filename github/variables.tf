variable "webhook_url" {
  type        = string
  default     = ""
  description = "The url to configure on the GitHub webhook. This endpoint will receive hooks whenever a workflow is triggered or completed enabling scaling on demand."
}
