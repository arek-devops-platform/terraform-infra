# Existing teams, to be adopted via `terraform import`. Values below were
# read directly from `gh api orgs/arek-devops-platform/teams/<slug>`.

resource "github_team" "developers" {
  name        = "developers"
  description = "Application developers"
  privacy     = "closed"

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_team" "platform" {
  name        = "platform"
  description = "DevOps / Platform team"
  privacy     = "closed"

  lifecycle {
    prevent_destroy = true
  }
}
