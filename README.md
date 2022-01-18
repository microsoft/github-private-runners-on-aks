# GitHub Self Hosted Runners

The goal of this repository is to demonstrate how to use GitHub private runners on an AKS cluster by leveraging [actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller).

![Flow](./img/flow.gif)

## Required Tooling

- [Terraform](https://www.terraform.io/)
- [Kapp](https://carvel.dev/kapp/)
- [Kustomize](https://kustomize.io/)

## GitHub integration

For AKS to be able to communicate with github, there are 2 possibilities:

- using an **ACCESS_TOKEN**: a GitHub Personal Access Token with at least `admin:org`, `admin:org_hook`, `notifications`, `read:public_key`, `read:repo_hook`, `repo` and `workflow` scopes.
- using a **GitHub App**: create one in your [organization](https://github.com/organizations/:org/settings/apps/new) (make sure to replace `:org` in the link by your organization name) or [account](https://github.com/settings/apps/new).
  - Note the **app_id**
  - Generate a private key, make sure to download the file as we'll need it to setup a secret
  - Install the GitHub App and note the **installation_id**
  - Add secret **GH_APP_PRIVATE_KEY** in the self hosted runners repository: the content of the private key generated in a previous step
  - Add secret **GH_ORG_WEBHOOK_ADMIN_ACCESS_TOKEN** in the self hosted runners repository: A personal access token with `admin:org_hook`, `repo` and `workflow` scopes.

## Solution organization

- `cluster_deployment` contains terraform configuration to manage the AKS cluster, its network and managed identities needed as part of the solution. Module documentation [here](cluster_deployment/module.md)
- `github` contains a terraform configuration to manage the github webhook to be configured on your organization enabling scaling on demand runners. Module documentation [here](github/module.md)
- `kubernetes` contains the different integrated solutions used in this solution and some custom configuration regarding the runners you need. Currently this solution leverages following components:
  - [Github Action Controller](https://github.com/actions-runner-controller/actions-runner-controller)
  - [AAD Pod Identity](https://github.com/Azure/aad-pod-identity)
  - [Cert Manager](https://cert-manager.io/docs/)
- `test` contains a dummy terraform configuration. It's useful to perform a resource deployment from the self hosted runners using the identity attached to it.

## Important notes

- RBAC roles must be set as per documentation
- actions-runner-controller: the webhook server can only be deployed with Helm Chart; thus a custom deployment has been added to this repository
- Avoid setting private runners on public repo since anyone can use them
- Estimated cost of this solution:
  - AKS Node (83.72€ for a DS2_v2 instance per month per node)
  - App GW (90,761€ per month). Note: can be replaced with an Nginx LB to reduce cost
