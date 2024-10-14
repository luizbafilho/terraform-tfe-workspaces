variable "workspaces" {
  description = "Map of workspaces definitions"
  type = map(object({
    allow_destroy_plan        = bool
    auto_apply                = bool
    description               = string
    env_vars                  = map(string)
    environment               = string
    execution_mode            = string
    global_remote_state       = bool
    project_name              = string
    queue_all_runs            = bool
    remote_state_consumer_ids = list(string)
    speculative_runs          = bool
    tag_names                 = list(string)
    terraform_vars            = map(string)
    terraform_version         = string
    vendors_vars              = list(string)
    working_directory_prefix  = string
    workspace_name            = optional(string)
  }))
}

variable "vcs" {
  description = "Settings for the workspace's VCS repository, enabling the UI/VCS-driven run workflow."
  type = object({
    branch                     = string
    identifier                 = string
    ingress_submodules         = bool
    oauth_token_id             = optional(string)
    github_app_installation_id = optional(string)
  })

  validation {
    condition = !(var.vcs["oauth_token_id"] != null && var.vcs["github_app_installation_id"] != null)
    error_message = "You must provide either 'oauth_token_id' or 'github_app_installation_id', but not both"
  }
}

variable "terraform_cloud_org" {
  description = "Terraform Cloud Org to create workspaces in"
  type        = string
}

variable "terraform_cloud_token" {
  description = "The Team token used to authenticate with Terraform Cloud. See [Authentication](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs#authentication) for more information"
  type        = string
}
