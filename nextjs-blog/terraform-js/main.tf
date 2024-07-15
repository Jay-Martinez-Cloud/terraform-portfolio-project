provider "aws" {
    region = "us-east-1"
  
}

#s3 bucket
resource "aws_s3_bucket" "nextjs_bucket" {
    bucket = "nextjs-portfolio-bucket-jm"
  
}

#ownership control
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls" {
  bucket = aws_s3_bucket.nextjs_bucket.id 

  rule {
    object_ownership = "BucketOwnerPrefferred"
  }
}

resource "aws_s3_bucket_public_access_block" "nextjs_bucket_public_access_block" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

#bucket acl 
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {

    depends_on = [
        aws_s3_bucket_ownership_controls.nextjs,
        aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
    ]
    bucket = aws_s3_bucket.nextjs_bucket.id
    acl = "public-read"
}

#bucket policy
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    policy = jsondecode((
        {
        version = "2012-10-17"
        Statment = [{
            Sid = "PublicReadGetObject"
            Effect = "Allow"
            Principal = "*"
            Action = "S3:GetObject"
            resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
        }
        ]
    }))
  
}