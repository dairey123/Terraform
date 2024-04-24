
variable "aws_access_key"{
    type = string
}

variable "aws_secret_key"{
    type = string
}

variable "ami_id"{
    type = string
    default = "ami-08447c25f2e9dc66c"
}

variable "type"{
    type = string
    default = "t2.micro"
}

variable "key"{
    type = string
    default = "dan"
}

variable "subnet_id"{
    type = string
    default = "subnet-07e675baf28e2db83"
}

variable "securitygroup_id"{
    type = string
    default = "sg-0f3adc9c5ffe846f0"
}


