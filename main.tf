data "aws_iam_role" "ecr_role" {
  name = "nobel_ECR_EC2" //name of the role in aws
}
resource "aws_iam_instance_profile" "iam" {
  name = "Iam"
  role = data.aws_iam_role.ecr_role.name
}
resource "aws_instance" "ec2" { 
  instance_type = "t2.micro"
  key_name="nobel_lavagna"
  ami           = "ami-0574da719dca65348" 
  iam_instance_profile = aws_iam_instance_profile.iam.name

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
    provisioner "file" {
        source      = "./install_docker.sh"
        destination = "/home/ubuntu/install_docker.sh"
     
   }
    provisioner "remote-exec" {
    inline = [

      "cd /home/ubuntu",
      "ls -la",
      "chmod a+x install_docker.sh",
      "./install_docker.sh", 
      "sudo docker --version", 
      "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-east-1.amazonaws.com",
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
 
 