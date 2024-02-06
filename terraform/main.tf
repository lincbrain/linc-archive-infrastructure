terraform {
  backend "remote" {
    organization = "linc-brain-mit"

    workspaces {
      name = "linc-archive-terraform"
    }
  }
}

provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = ["151312473579"]

  assume_role {
      role_arn = "arn:aws:iam::151312473579:role/linc-infrastructure"
   }
}

// The "sponsored" account, the Amazon-sponsored account with the public bucket
provider "aws" {
  alias               = "sponsored"
  region              = "us-east-1"
  allowed_account_ids = ["151312473579"]  # TODO: Aaron make new ID

  // This will authenticate using credentials from the project account, then assume the
  // "linc-infrastructure" role from the sponsored account to manage resources there
  assume_role {
    role_arn = "arn:aws:iam::151312473579:role/linc-infrastructure"
  }

  # Must set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY envvars for project account
}

provider "heroku" {

}

provider "sentry" {
  # Must set SENTRY_AUTH_TOKEN envvar
}

data "aws_canonical_user_id" "project_account" {}

data "aws_caller_identity" "project_account" {}

data "aws_canonical_user_id" "sponsored_account" {
  provider = aws.sponsored
}

data "aws_caller_identity" "sponsored_account" {
  provider = aws.sponsored
}
