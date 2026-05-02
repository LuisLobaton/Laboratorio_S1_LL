# Security Groups para las Lambdas
resource "aws_security_group" "sg_upload" {
  name   = "sg-upload-${terraform.workspace}"
  vpc_id = aws_vpc.main.id
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
}

resource "aws_security_group" "sg_crop" {
  name   = "sg-crop-${terraform.workspace}"
  vpc_id = aws_vpc.main.id
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
}

# Empaquetado
data "archive_file" "upload_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/uploads"
  output_path = "${path.module}/upload.zip"
}

data "archive_file" "crop_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/crop"
  output_path = "${path.module}/crop.zip"
}

# Funciones
resource "aws_lambda_function" "upload_lambda" {
  function_name = "upload-lambda-${terraform.workspace}"
  role          = aws_iam_role.upload_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = data.archive_file.upload_zip.output_path
  source_code_hash = data.archive_file.upload_zip.output_base64sha256
  vpc_config {
    subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_group_ids = [aws_security_group.sg_upload.id]
  }
}

resource "aws_lambda_function" "crop_lambda" {
  function_name = "crop-lambda-${terraform.workspace}"
  role          = aws_iam_role.crop_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = data.archive_file.crop_zip.output_path
  source_code_hash = data.archive_file.crop_zip.output_base64sha256
  vpc_config {
    subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_group_ids = [aws_security_group.sg_crop.id]
  }
}

# Trigger SQS
resource "aws_lambda_event_source_mapping" "sqs_to_crop" {
  event_source_arn = aws_sqs_queue.main_queue.arn
  function_name    = aws_lambda_function.crop_lambda.arn
}