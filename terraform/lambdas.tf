# Security Group para la Lambda de Subida
resource "aws_security_group" "sg_upload" {
  name   = "sg-upload-${terraform.workspace}"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group para la Lambda de Recorte
resource "aws_security_group" "sg_crop" {
  name   = "sg-crop-${terraform.workspace}"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}