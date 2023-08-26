#1. S3 bucket
resource "aws_s3_bucket" "backend" {
  count = var.create_vpc ? 1 : 0

  #bucket = "lower(bootcamp29-${random_integer.s3.result}-${var.name}"
  bucket = "my-elk-testing-bucket-254"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

#2. Bucket ACL
#resource "aws_s3_bucket_acl" "example" {
# bucket = aws_s3_bucket.backend[0].id
# acl    = var.acl
#}

##############################################################################
resource "aws_s3_bucket_public_access_block" "my_bucket" {
  bucket = aws_s3_bucket.backend[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "my_bucket" {
  bucket        = aws_s3_bucket.backend[0].bucket
  target_bucket = "landmark-automation-kenmak"
  target_prefix = "log-elk/"
}


#3. Bucket versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.backend[0].id
  versioning_configuration {
    status = var.versioning
  }
}

#4. Random integer
resource "random_integer" "s3" {
  max = 100
  min = 1

  keepers = {
    bucket_owner = var.name
  }
}

#5. KMS for bucket encryption
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

#6. Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}





