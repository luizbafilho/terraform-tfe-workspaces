resource "tfe_workspace" "this" {
  for_each            = var.workspaces
  project_id          = data.tfe_project.this[each.key].id
  allow_destroy_plan  = each.value.allow_destroy_plan
  auto_apply          = each.value.auto_apply
  description         = each.value.description
  name                = lookup(each.value, "workspace_name", null) != null ? each.value.workspace_name : "${each.key}-${each.value.environment}"
  organization        = var.terraform_cloud_org
  queue_all_runs      = each.value.queue_all_runs
  speculative_enabled = each.value.speculative_runs
  tag_names           = each.value.tag_names
  terraform_version   = each.value.terraform_version

  working_directory = "${lookup(each.value, "working_directory_prefix", "")}/${each.key}/"
  vcs_repo {
    branch                     = var.vcs["branch"]
    identifier                 = var.vcs["identifier"]
    ingress_submodules         = var.vcs["ingress_submodules"]
    oauth_token_id             = var.vcs["oauth_token_id"]
    github_app_installation_id = var.vcs["github_app_installation_id"]
  }
}

resource "tfe_workspace_settings" "this" {
  for_each                  = var.workspaces
  workspace_id              = tfe_workspace.this[each.key].id
  execution_mode            = each.value.execution_mode
  global_remote_state       = each.value.global_remote_state
  remote_state_consumer_ids = each.value.global_remote_state == false ? each.value.remote_state_consumer_ids : null
}

resource "tfe_workspace_variable_set" "this" {
  for_each = {
    for item in flatten([
      for ws_key, ws in var.workspaces : [
        for vs_id in coalesce(ws.variable_set_ids, []) : {
          workspace_key = ws_key
          varset_id     = vs_id
        }
      ]
    ]) : "${item.workspace_key}.${item.varset_id}" => item
  }

  variable_set_id = each.value.varset_id
  workspace_id    = tfe_workspace.this[each.value.workspace_key].id
}
