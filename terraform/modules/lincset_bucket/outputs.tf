output "bucket_name" {
  value       = aws_s3_bucket.lincset_bucket.id
  description = "The S3 bucket name."
}

output "log_bucket_name" {
  value       = aws_s3_bucket.log_bucket.id
  description = "The S3 log bucket name."
}

output "bucket_arn" {
  value       = aws_s3_bucket.lincset_bucket.arn
  description = "The S3 bucket ARN."
}

output "bucket_name_us_east_2" {
  value       = aws_s3_bucket.lincset_bucket_us_east_2.id
  description = "The S3 bucket name."
}

output "log_bucket_name_us_east_2" {
  value       = aws_s3_bucket.log_bucket_us_east_2.id
  description = "The S3 log bucket name."
}

output "bucket_arn_us_east_2" {
  value       = aws_s3_bucket.lincset_bucket_us_east_2.arn
  description = "The S3 bucket ARN."
}
