module "staging_lincset_bucket" {
  source                  = "./modules/lincset_bucket"
  bucket_name             = "linc-api-staging-lincsets"
  public                  = true
  versioning              = true
  trailing_delete         = true
  allow_heroku_put_object = true
  heroku_user             = data.aws_iam_user.api_staging
  log_bucket_name         = "linc-api-staging-lincset-logs"
  providers = {
    aws         = aws
    aws.project = aws
  }
}

module "staging_embargo_bucket" {
  source          = "./modules/lincset_bucket"
  bucket_name     = "linc-api-staging-embargo-lincsets"
  versioning      = false
  trailing_delete = false
  heroku_user     = data.aws_iam_user.api_staging
  log_bucket_name = "linc-api-staging-embargo-lincset-logs"
  providers = {
    aws         = aws
    aws.project = aws
  }
}