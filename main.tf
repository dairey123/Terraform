provider "aws" {
    region = "eu-west-2"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

module vpc {
    source = "./modules./vpc/"
}

#module db {
#    source = "./modules/db"
#
#    
#    my_db_subnet_group = module.vpc.subnet_group_value
#    my_db_security_group = module.vpc.security_group_value
#    get_endpoint = module.db.endpoint
#}
module webserver {
    source = "./modules/webserver"
    my_public_subnet = module.vpc.public_subnet_id
    my_public_sg = module.vpc.security_group_app_id
    get_public_ip = module.webserver.public_ip
}
