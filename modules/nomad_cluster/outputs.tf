output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.default : s.cidr_block]
}

output "role_arn" {
  value = aws_iam_role.instance_role.arn
}