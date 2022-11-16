resource "aws_s3_bucket" "bucket" {

  bucket = "korrestorebucket"

  versioning {
    enabled = false
  }
}



