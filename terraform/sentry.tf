data "sentry_organization" "this" {
  slug = "lincbrain"
}

data "sentry_team" "this" {
  organization = data.sentry_organization.this.id
  slug         = "linc-brain-devs"
}

data "sentry_project" "this" {
  organization = data.sentry_organization.this.id
  slug         = "dandi-api"
}

data "sentry_key" "this" {
  organization = data.sentry_organization.this.id
  project      = data.sentry_project.this.id
}
