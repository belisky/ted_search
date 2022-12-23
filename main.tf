resource "aws_instance" "ec2" { 
  instance_type = "t2.micro"
  key_name="nobel_lavagna"
  ami           = "ami-0574da719dca65348" 

    user_data       = "${file("install_docker.sh")}"
    vpc_security_group_ids = ["${aws_security_group.sg.id}"] 

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/nobel_lavagna.pem")
      host        = self.public_ip
    }
   provisioner "file" {
        source      = "./docker-compose-ec2.yml"
        destination = "/home/ubuntu/docker-compose.yml"
     
   }
    provisioner "remote-exec" {
    inline = [

      "cd /home/ubuntu",
      "ls -la",
      " sudo apt-get install -y ca-certificates curl gnupg lsb-release",
       "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
       "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
       "sudo apt-get update", 
       "sudo chmod a+r /etc/apt/keyrings/docker.gpg",  
       "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y",
       "sudo docker --version",       
       "sudo docker compose -p ts up -d --wait",
    ]

    }
}
resource "aws_security_group" "sg" {
  name        = "webSG"
  description = "Allow ssh  inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 8084
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
}
 
 