resource  "aws_db_instance" "myDatabase" {
    identifier = "mydb"
    allocated_storage = 10
    engine = "mysql"
    engine_version = "8.0.35"
    instance_class = "db.t3.micro"
    db_name = "mydb"
    username = "dan"
    password = "password"
    port = "3306"
    skip_final_snapshot = true
    iam_database_authentication_enabled = false
    db_subnet_group_name  = var.my_db_subnet_group
    vpc_security_group_ids = [var.my_db_security_group]
    
}
