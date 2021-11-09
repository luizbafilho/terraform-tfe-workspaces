resource "tfe_workspace" "this" {
  for_each                  = var.workspaces
  allow_destroy_plan        = var.allow_destroy_plan
  auto_apply                = var.auto_apply
  description               = each.value["description"]
  execution_mode            = var.execution_mode
  global_remote_state       = var.global_remote_state
  name                      = "${each.key}-${var.environment}"
  organization              = var.terraform_cloud_org
  queue_all_runs            = var.queue_all_runs
  remote_state_consumer_ids = var.remote_state_consumer_ids
  speculative_enabled       = var.speculative_enabled
  tag_names                 = var.tag_names
  terraform_version         = each.value["terraform_version"]
  working_directory         = "${each.key}/"
  vcs_repo {
    branch             = var.vcs["branch"]
    identifier         = var.vcs["identifier"]
    ingress_submodules = var.vcs["ingress_submodules"]
    oauth_token_id     = var.vcs["oauth_token_id"]
  }
}