data "aws_canonical_user_id" "log_bucket_owner_account" {}

resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "lincset_log_bucket_policy" {
  statement {
    resources = [
      "${aws_s3_bucket.log_bucket.arn}",
      "${aws_s3_bucket.log_bucket.arn}/*",
    ]

    actions = [
      # Needed for the app to process logs for collecting download analytics
      "s3:GetObject",
      "s3:ListBucket",
    ]

    principals {
      type        = "AWS"
      identifiers = [var.heroku_user.arn]
    }
  }

  statement {
    sid       = "S3ServerAccessLogsPolicy"
    effect    = "Allow"
    resources = ["${aws_s3_bucket.log_bucket.arn}/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.lincset_bucket.arn]
    }

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "lincset_log_bucket_policy" {
  provider = aws

  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.lincset_log_bucket_policy.json
}

data "aws_iam_policy_document" "lincset_log_bucket_owner" {
  version = "2008-10-17"

  // TODO: gate behind a "cross account" flag, since this is technically only
  // needed for sponsored log bucket.
  statement {
    resources = [
      "${aws_s3_bucket.log_bucket.arn}",
      "${aws_s3_bucket.log_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
  }
}

resource "aws_iam_user_policy" "lincset_log_bucket_owner" {
  // The Heroku IAM user will always be in the project account
  provider = aws.project

  name = "${var.log_bucket_name}-ownership-policy"
  user = var.heroku_user.user_name

  policy = data.aws_iam_policy_document.lincset_log_bucket_owner.json
}

# data "aws_canonical_user_id" "log_bucket_owner_account" {}

resource "aws_s3_bucket" "log_bucket_us_east_2" {
  bucket = var.log_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_us_east_2" {
  bucket = aws_s3_bucket.log_bucket_us_east_2.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "lincset_log_bucket_policy_us_east_2" {
  statement {
    resources = [
      "${aws_s3_bucket.log_bucket_us_east_2.arn}",
      "${aws_s3_bucket.log_bucket_us_east_2.arn}/*",
    ]

    actions = [
      # Needed for the app to process logs for collecting download analytics
      "s3:GetObject",
      "s3:ListBucket",
    ]

    principals {
      type        = "AWS"
      identifiers = [var.heroku_user.arn]
    }
  }

  statement {
    sid       = "S3ServerAccessLogsPolicy"
    effect    = "Allow"
    resources = ["${aws_s3_bucket.log_bucket_us_east_2.arn}/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.lincset_bucket_us_east_2.arn]
    }

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "lincset_log_bucket_policy_us_east_2" {
  provider = aws

  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.lincset_log_bucket_policy_us_east_2.json
}

data "aws_iam_policy_document" "lincset_log_bucket_owner_us_east_2" {
  version = "2008-10-17"

  // TODO: gate behind a "cross account" flag, since this is technically only
  // needed for sponsored log bucket.
  statement {
    resources = [
      "${aws_s3_bucket.log_bucket_us_east_2.arn}",
      "${aws_s3_bucket.log_bucket_us_east_2.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
  }
}

resource "aws_iam_user_policy" "lincset_log_bucket_owner_us_east_2" {
  // The Heroku IAM user will always be in the project account
  provider = aws.project

  name = "${var.log_bucket_name}-ownership-policy"
  user = var.heroku_user.user_name

  policy = data.aws_iam_policy_document.lincset_log_bucket_owner_us_east_2.json
}

