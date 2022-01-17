resource "github_organization_webhook" "workflow_jobs" {
  configuration {
    url          = var.webhook_url
    content_type = "json"
    insecure_ssl = false
  }

  active = true
  events = ["workflow_job"]
}
