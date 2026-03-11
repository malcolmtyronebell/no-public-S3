package s3policy

deny contains message if {
  input.resource_type == "aws_s3_bucket"
  input.acl == "public-read"
  message := "S3 buckets cannot be publicly readable (acl: public-read)"
}
