resource "aws_instance" "myServer" {
    ami = "ami-08447c25f2e9dc66c"
    instance_type = "t2.micro"
    key_name = "dan"
    associate_public_ip_address = true
    subnet_id = var.my_public_subnet
    private_ip = "10.0.1.10"
    security_groups = [var.my_public_sg]
    user_data = <<-EOL
        #!/bin/bash
        sudo apt update
        EOL
}

resource "null_resource" "connect_web" {
    provisioner "remote-exec" {
        inline = [
            "sudo echo 'ubuntu ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo"
        ]
        connection {
          host = aws_instance.myServer.public_ip
          type = "ssh"
          user = "ubuntu"
          private_key = file("./myKey")
        }
    }
    depends_on = [aws_instance.myServer]
}

resource "null_resource" "execute_ansible" {
    provisioner "remote-exec" {
        inline = [
            "sudo apt update",
            "sudo apt install software-properties-common",
            "sudo add-apt-repository --yes --update ppa:ansible/ansible",
            "sudo apt install ansible -y",
            "sudo git clone https://github.com/nathanforester/ansible-auto.git",
            "sudo ansible-playbook -v /home/ubuntu/ansible-auto/playbook.yaml"
         ]  
        connection {
          host = aws_instance.myServer.public_ip
          type = "ssh"
          user = "ubuntu"
          private_key = file("./myKey")
        }
    }
    depends_on = [ aws_instance.myServer, null_resource.connect_web]
  
}