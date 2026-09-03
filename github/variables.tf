variable "github_organization" {
  description = "GitHub organization that owns every resource in this configuration."
  type        = string
  default     = "arek-devops-platform"
}

variable "reviewer_username" {
  description = "GitHub username of the required reviewer for prod/infra-prod Environments and the Ruleset's pull-request-only bypass actor (currently a one-person lab, so this is the repo owner)."
  type        = string
  default     = "arexo14"
}
