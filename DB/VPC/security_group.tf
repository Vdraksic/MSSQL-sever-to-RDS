resource "aws_security_group" "RDS" {
  name        = "Allow_RDS_connection"
  description = "Allow_RDS_connection"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow port: ${var.port}"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}