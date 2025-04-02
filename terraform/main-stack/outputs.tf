output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "private_subnets_arn" {
  value = aws_subnet.private[*].arn
}

output "public_subnets_arn" {
  value = aws_subnet.public[*].arn
}
