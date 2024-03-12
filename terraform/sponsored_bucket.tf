module "sponsored_lincset_bucket" {
  source                                = "./modules/lincset_bucket"
  bucket_name                           = "linc-brain-mit-prod"
  public                                = false
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

module "sponsored_lincset_bucket-us-east-2" {
  source                                = "./modules/lincset_bucket"
  bucket_name                           = "linc-brain-mit-prod-us-east-2"
  public                                = false
  versioning                            = true
  trailing_delete                       = false
  allow_cross_account_heroku_put_object = true
  heroku_user                           = data.aws_iam_user.api
  log_bucket_name                       = "linc-brain-mit-logs-us-east-2"
  providers = {
    aws         = aws.target
    aws.project = aws
  }
}

module "sponsored_embargo_bucket-us-east-2" {
  source          = "./modules/lincset_bucket"
  bucket_name     = "linc-brain-mit-embargo-prod-us-east-2"
  versioning      = false
  trailing_delete = false
  heroku_user     = data.aws_iam_user.api
  log_bucket_name = "linc-brain-mit-embargo-logs-us-east-2"
  providers = {
    aws         = aws.target
    aws.project = aws
  }
}
