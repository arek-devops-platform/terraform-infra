# Reproduces the existing "Protect main" ruleset on app-demo as accurately
# as the provider schema allows. Every value below was read directly from:
#   gh api repos/arek-devops-platform/app-demo/rulesets/21947935
# not guessed.
#
# Two settings observed in that API response have NO corresponding argument
# in the github_repository_ruleset provider schema, and are both already at
# their default/off value, so nothing is lost by omitting them - flagged
# here rather than silently dropped:
#   - dismissal_restriction.enabled: false (not exposed by the provider)
#   - require_extra_approval_for_unattributed_changes: false (not exposed)
# TODO: if either of these is ever turned ON in GitHub's UI, this resource
# will not be able to represent that - check the provider's changelog for
# newer support before assuming Terraform still matches reality.
resource "github_repository_ruleset" "app_demo_protect_main" {
  name        = "Protect main"
  repository  = github_repository.app_demo.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  # The existing pull-request-only bypass for the repo owner - a one-person
  # lab exception, not a general bypass (bypass_mode = "pull_request" means
  # this actor can only skip the rules on pull requests, never on a direct
  # push).
  bypass_actors {
    actor_id    = data.github_user.reviewer.id
    actor_type  = "User"
    bypass_mode = "pull_request"
  }

  rules {
    deletion         = true # restrict deletions
    non_fast_forward = true # block force pushes

    pull_request {
      required_approving_review_count   = 1
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = true
      required_review_thread_resolution = true
      require_last_push_approval        = false
      allowed_merge_methods             = ["merge", "squash", "rebase"]
    }

    required_status_checks {
      strict_required_status_checks_policy = true
      do_not_enforce_on_create             = false

      # integration_id 15368 is the GitHub Actions App ID for this org, as
      # returned directly by the ruleset API - not guessed.
      required_check {
        context        = "test / test"
        integration_id = 15368
      }
      required_check {
        context        = "security / SAST - Bandit"
        integration_id = 15368
      }
      required_check {
        context        = "security / SCA - pip-audit"
        integration_id = 15368
      }
      required_check {
        context        = "security / Secret Scanning - Gitleaks"
        integration_id = 15368
      }
      required_check {
        context        = "Pull Request: Test & Verify Docker Build"
        integration_id = 15368
      }
      required_check {
        context        = "docker / Trivy - Container Image Scan"
        integration_id = 15368
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
