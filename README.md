# GitHub Self Hosted Runners

## Pre requisites

- Add secrets in the self hosted runners repository: 
    - **ARM_CLIENT_ID**: an Azure Service Principal Client ID which will be used to deploy infrastructure
    - **ARM_CLIENT_SECRET**: an Azure Service Principal Client Secret which will be used to deploy infrastructure
    - **ARM_TENANT_ID**: the tenant ID where the Azure Service Principal lives

In case you want your runners to be able to register/unregister to GitHub runners pool using a PAT, you'll have to create following secret: 
    
- **ACCESS_TOKEN**: a GitHub Personal Access Token with at least `admin:org`, `admin:org_hook`, `notifications`, `read:public_key`, `read:repo_hook`, `repo` and `workflow` scopes.

In case you want your runners to be able to register/unregister to GitHub runners pool using a GitHub App, you'll have to:
- Create a GitHub App on your [organization](https://github.com/organizations/:org/settings/apps/new?url=http://github.com/actions-runner-controller/actions-runner-controller&webhook_active=false&public=false&administration=write&organization_self_hosted_runners=write&actions=read&checks=read) (make sure to replace `:org` in the link by your organization name) / [account](https://github.com/settings/apps/new?url=http://github.com/actions-runner-controller/actions-runner-controller&webhook_active=false&public=false&administration=write&actions=read).
- Generate a private key, make sure to download the file as we'll need it to setup a secret
- Install the GitHub App
- Add secret **GH_APP_PRIVATE_KEY** in the self hosted runners repository: the content of the private key generated in a previous step
- Add secret **GH_ORG_WEBHOOK_ADMIN_ACCESS_TOKEN** in the self hosted runners repository: A personal access token with `admin:org_hook`, `repo` and `workflow` scopes.

## Tooling used:
- [Terraform](https://www.terraform.io/)
- [KApp](https://carvel.dev/kapp/)
- [Kustomize](https://kustomize.io/)

## Solution organization:

- `cluster_deployment` folder contains terraform configuration to manage the AKS cluster, its network and managed identities needed as part of the solution. Module documentation is [here](cluster_deployment/module.md)

- `github` folder contains a terraform configuration to manage the github webhook to be configured on your organization enabling scaling on demand runners. Module documentation is [here](github/module.md)

- `kubernetes` folder contains the different integrated solutions used in this solution and some custom configuration regarding the runners you need. Currently this solution leverages following components : 
    - [Github Action Controller](https://github.com/actions-runner-controller/actions-runner-controller)
    - [AAD Pod Identity](https://github.com/Azure/aad-pod-identity)
    - [Cert Manager](https://cert-manager.io/docs/)

- `test` folder contains a dummy terraform configuration. It's useful to perform a resource deployment from the self hosted runners using the identity attached to it.
