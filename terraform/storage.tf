# Cola para los mensajes fallidos
resource "aws_sqs_queue" "dlq" {
  name                      = "image-processor-${terraform.workspace}-image-dlq"
  message_retention_seconds = 1209600 # Los 14 días que pide el diagrama
}

# Cola principal
resource "aws_sqs_queue" "main_queue" {
  name                       = "image-processor-${terraform.workspace}-image-queue"
  visibility_timeout_seconds = 360
  receive_wait_time_seconds  = 20
  
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}

# Bucket S3
resource "aws_s3_bucket" "images" {
  bucket        = "image-processor-${terraform.workspace}-images-ll"
  force_destroy = true 
}

resource "aws_s3_bucket_versioning" "images_versioning" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration {
    status = "Enabled"
  }
}

# prefijos
resource "aws_s3_object" "uploads_folder" {
  bucket = aws_s3_bucket.images.id
  key    = "uploads/"
}

resource "aws_s3_object" "processed_folder" {
  bucket = aws_s3_bucket.images.id
  key    = "processed/"
}