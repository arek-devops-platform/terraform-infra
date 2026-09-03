# Existing repositories, adopted via `terraform import` - see
# import-existing.ps1. Nothing here creates a repository.
#
# Every setting below was verified field-by-field via read-only inspection
# (`gh api repos/arek-devops-platform/<repo>`) - none of it is guessed. All
# three repositories currently have identical values for every one of these
# fields (they're GitHub's standard repository-creation defaults, never
# customized). Declaring them explicitly - rather than leaving the
# provider's own schema defaults to apply - is what keeps `terraform plan`
# at zero-change: `has_issues`, `has_projects`, and `has_wiki` in particular
# are plain Optional attributes in this provider (not Optional+Computed), so
# omitting them does not mean "leave as-is" - it means "set to false", which
# previously caused a drift on every plan since GitHub's real value is true.
#
# `has_downloads` and `ignore_vulnerability_alerts_during_read` were
# previously declared here too, but the provider reports both as deprecated
# with no replacement argument - `has_downloads` "is no longer in use" and
# `ignore_vulnerability_alerts_during_read` "is ignored as the provider now
# handles lack of permissions automatically". Neither corresponds to a real,
# settable GitHub feature any more, so removing them changes nothing about
# the actual desired configuration - it only removes two permanent no-op
# warnings.
locals {
  # Single source of truth for the settings shared identically by all three
  # repositories today, so the three resources below can't drift apart from
  # each other by a copy-paste mistake.
  verified_repository_defaults = {
    has_issues                  = true
    has_projects                = true
    has_wiki                    = true
    archived                    = false
    delete_branch_on_merge      = false
    allow_merge_commit          = true
    allow_squash_merge          = true
    allow_rebase_merge          = true
    allow_auto_merge            = false
    merge_commit_title          = "MERGE_MESSAGE"
    merge_commit_message        = "PR_TITLE"
    squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
    squash_merge_commit_message = "COMMIT_MESSAGES"
    web_commit_signoff_required = false
  }
}

resource "github_repository" "app_demo" {
  name       = "app-demo"
  visibility = "public"

  has_issues                  = local.verified_repository_defaults.has_issues
  has_projects                = local.verified_repository_defaults.has_projects
  has_wiki                    = local.verified_repository_defaults.has_wiki
  archived                    = local.verified_repository_defaults.archived
  delete_branch_on_merge      = local.verified_repository_defaults.delete_branch_on_merge
  allow_merge_commit          = local.verified_repository_defaults.allow_merge_commit
  allow_squash_merge          = local.verified_repository_defaults.allow_squash_merge
  allow_rebase_merge          = local.verified_repository_defaults.allow_rebase_merge
  allow_auto_merge            = local.verified_repository_defaults.allow_auto_merge
  merge_commit_title          = local.verified_repository_defaults.merge_commit_title
  merge_commit_message        = local.verified_repository_defaults.merge_commit_message
  squash_merge_commit_title   = local.verified_repository_defaults.squash_merge_commit_title
  squash_merge_commit_message = local.verified_repository_defaults.squash_merge_commit_message
  web_commit_signoff_required = local.verified_repository_defaults.web_commit_signoff_required

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository" "platform_workflows" {
  name       = "platform-workflows"
  visibility = "public"

  has_issues                  = local.verified_repository_defaults.has_issues
  has_projects                = local.verified_repository_defaults.has_projects
  has_wiki                    = local.verified_repository_defaults.has_wiki
  archived                    = local.verified_repository_defaults.archived
  delete_branch_on_merge      = local.verified_repository_defaults.delete_branch_on_merge
  allow_merge_commit          = local.verified_repository_defaults.allow_merge_commit
  allow_squash_merge          = local.verified_repository_defaults.allow_squash_merge
  allow_rebase_merge          = local.verified_repository_defaults.allow_rebase_merge
  allow_auto_merge            = local.verified_repository_defaults.allow_auto_merge
  merge_commit_title          = local.verified_repository_defaults.merge_commit_title
  merge_commit_message        = local.verified_repository_defaults.merge_commit_message
  squash_merge_commit_title   = local.verified_repository_defaults.squash_merge_commit_title
  squash_merge_commit_message = local.verified_repository_defaults.squash_merge_commit_message
  web_commit_signoff_required = local.verified_repository_defaults.web_commit_signoff_required

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository" "terraform_infra" {
  name       = "terraform-infra"
  visibility = "public"

  has_issues                  = local.verified_repository_defaults.has_issues
  has_projects                = local.verified_repository_defaults.has_projects
  has_wiki                    = local.verified_repository_defaults.has_wiki
  archived                    = local.verified_repository_defaults.archived
  delete_branch_on_merge      = local.verified_repository_defaults.delete_branch_on_merge
  allow_merge_commit          = local.verified_repository_defaults.allow_merge_commit
  allow_squash_merge          = local.verified_repository_defaults.allow_squash_merge
  allow_rebase_merge          = local.verified_repository_defaults.allow_rebase_merge
  allow_auto_merge            = local.verified_repository_defaults.allow_auto_merge
  merge_commit_title          = local.verified_repository_defaults.merge_commit_title
  merge_commit_message        = local.verified_repository_defaults.merge_commit_message
  squash_merge_commit_title   = local.verified_repository_defaults.squash_merge_commit_title
  squash_merge_commit_message = local.verified_repository_defaults.squash_merge_commit_message
  web_commit_signoff_required = local.verified_repository_defaults.web_commit_signoff_required

  lifecycle {
    prevent_destroy = true
  }
}
