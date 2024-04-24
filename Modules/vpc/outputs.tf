output "public_subnet_id" {
    value = aws_subnet.myPublicSubnet.id
}
output "security_group_app_id" {
    value = aws_security_group.mySG.id
}
output "subnet_group_value" {
    value = aws_db_subnet_group.maindba.id
}
output "security_group_value" {
    value = aws_security_group.mySGDB.id
}
