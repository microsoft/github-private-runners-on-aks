<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 4.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_organization_webhook.workflow_jobs](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_webhook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | The url to configure on the GitHub webhook. This endpoint will receive hooks whenever a workflow is triggered or completed enabling scaling on demand. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->