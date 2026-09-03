# Existing team-to-repository permissions, to be adopted via
# `terraform import`. Values below were read directly from
# `gh api orgs/arek-devops-platform/teams/<slug>/repos` and match the
# intended permissions exactly:
#   developers -> app-demo:            Write     (provider value: "push")
#   platform   -> app-demo:            Maintain  (provider value: "maintain")
#   platform   -> platform-workflows:  Maintain
#   platform   -> terraform-infra:     Maintain

resource "github_team_repository" "developers_app_demo" {
  team_id    = github_team.developers.id
  repository = github_repository.app_demo.name
  permission = "push" # GitHub UI calls this "Write"
}

resource "github_team_repository" "platform_app_demo" {
  team_id    = github_team.platform.id
  repository = github_repository.app_demo.name
  permission = "maintain"
}

resource "github_team_repository" "platform_platform_workflows" {
  team_id    = github_team.platform.id
  repository = github_repository.platform_workflows.name
  permission = "maintain"
}

resource "github_team_repository" "platform_terraform_infra" {
  team_id    = github_team.platform.id
  repository = github_repository.terraform_infra.name
  permission = "maintain"
}
