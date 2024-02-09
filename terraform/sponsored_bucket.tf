module "sponsored_lincset_bucket" {
  source                                = "./modules/lincset_bucket"
  bucket_name                           = "linc-brain-mit-prod"
  public                                = true
  versioning                            = true
  trailing_delete                       = false
  allow_cross_account_heroku_put_object = true
  heroku_user                           = data.aws_iam_user.api
  log_bucket_name                       = "linc-brain-mit-logs"
  providers = {
    aws         = aws.sponsored
    aws.project = aws
  }
}

module "sponsored_embargo_bucket" {
  source          = "./modules/lincset_bucket"
  bucket_name     = "linc-brain-mit-embargo-prod"
  versioning      = false
  trailing_delete = false
  heroku_user     = data.aws_iam_user.api
  log_bucket_name = "linc-brain-mit-embargo-logs"
  providers = {
    aws         = aws.sponsored
    aws.project = aws
  }
}
