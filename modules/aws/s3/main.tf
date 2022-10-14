
variable "bucket_name" {
  description = "S3 bucket name"
}

variable "project_name" {
   description = "Project Name"
}

variable "management_name" {
}

########################
# Bucket creation
########################
resource "aws_s3_bucket" "my_protected_bucket" {
  bucket = var.bucket_name
  tags = {
      Name = "${var.management_name}-jenkins-instance"
      Project = "${var.project_name}"    
   }
}

##########################
# Bucket private access
##########################
resource "aws_s3_bucket_acl" "my_protected_bucket_acl" {
  bucket = aws_s3_bucket.my_protected_bucket.id
  acl    = "private"
}