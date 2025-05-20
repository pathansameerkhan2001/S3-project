# creating s3 bucket in AWS by using terraform
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket-Name

}
# creating the ownership of bucket 
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# creating aws_s3_bucket_public_access_block

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# creating the aws_s3_bucket_acl

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# creating object: aws_s3_object for index.html

resource "aws_s3_object" "index" {
 bucket = aws_s3_bucket.mybucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

# creating object: aws_s3_object for error.html

resource "aws_s3_object" "error" {
 bucket = aws_s3_bucket.mybucket.id
  key = "error.html"
  source = "error.html"
  content_type = "text/html"
}

# creating object: aws_s3_object for img.JPG
resource "aws_s3_object" "img" {
 bucket = aws_s3_bucket.mybucket.id
  key = "img.JPG"
  source = "img.JPG"
  acl = "public-read"
}

# creating Resource: aws_s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id
  
   index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
depends_on = [ aws_s3_bucket_acl.example ]
}
