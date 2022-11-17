output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets_public" {
  value = aws_subnet.public_subnet[*].id
}

output "security_group" {
  value = aws_security_group.RDS.id

}