resource "aws_vpc" "myNewVPC" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "myGW" {
    vpc_id = aws_vpc.myNewVPC.id
}


resource "aws_subnet" "myPublicSubnet" {
    vpc_id = aws_vpc.myNewVPC.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-2a"
    map_public_ip_on_launch = true
}
resource "aws_subnet" "myPrivateSubnet1" {
    vpc_id = aws_vpc.myNewVPC.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-2a"
}
resource "aws_subnet" "myPrivateSubnet2" {
    vpc_id = aws_vpc.myNewVPC.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-2b"
}

resource "aws_route_table" "myPublicRT" {
    vpc_id = aws_vpc.myNewVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myGW.id
    }
}

resource "aws_route_table_association" "routePublic" {
    subnet_id = aws_subnet.myPublicSubnet.id
    route_table_id = aws_route_table.myPublicRT.id
}

resource "aws_route_table" "myPrivateRT" {
    vpc_id = aws_vpc.myNewVPC.id
}

resource "aws_route_table_association" "routePrivate1" {
    subnet_id = aws_subnet.myPrivateSubnet1.id
    route_table_id = aws_route_table.myPrivateRT.id
}
resource "aws_route_table_association" "routePrivate2" {
    subnet_id = aws_subnet.myPrivateSubnet2.id
    route_table_id = aws_route_table.myPrivateRT.id
}

resource "aws_db_subnet_group" "maindba" {
    name = "maindba"
    subnet_ids = [aws_subnet.myPrivateSubnet1.id,aws_subnet.myPrivateSubnet2.id]

    tags = {
        Name = "My DB subnet group"
    }
}

resource "aws_security_group" "mySG" {
    name = "my-SG"
    description = "ssh and port 80 access"
    vpc_id = aws_vpc.myNewVPC.id

        ingress {
            description = "http"
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
        ingress {
            description = "ssh"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
            to_port = 0
            from_port = 0
            protocol = -1
            cidr_blocks = ["0.0.0.0/0"]    
        }
}

resource "aws_security_group" "mySGDB" {
    name = "my-SG-DB"
    description = "ssh and port 80 access"
    vpc_id = aws_vpc.myNewVPC.id

        ingress {
            description = "mysql"
            from_port = 3306
            to_port = 3306
            protocol = "tcp"
            security_groups = [aws_security_group.mySG.id]
        }
        egress {
            to_port = 0
            from_port = 0
            protocol = -1
            cidr_blocks = ["0.0.0.0/0"]    
        }
}