output "repository_ids" {
  description = "Numeric repository IDs, keyed by repository name."
  value = {
    (github_repository.app_demo.name)           = github_repository.app_demo.repo_id
    (github_repository.platform_workflows.name) = github_repository.platform_workflows.repo_id
    (github_repository.terraform_infra.name)    = github_repository.terraform_infra.repo_id
  }
}

output "team_ids" {
  description = "Numeric team IDs, keyed by team slug."
  value = {
    (github_team.developers.slug) = github_team.developers.id
    (github_team.platform.slug)   = github_team.platform.id
  }
}

output "ruleset_id" {
  description = "Numeric ID of the app-demo main-branch ruleset."
  value       = github_repository_ruleset.app_demo_protect_main.ruleset_id
}
