resource "aws_instance" "ec2" { 
  instance_type = "t2.micro"
  ami           = "ami-0574da719dca65348" 


   provisioner "file" {
        source      = "docker-compose-ec2.yml"
        destination = "/home/ubuntu/docker-compose.yml"
       
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("/nobel_lavagna.pem")}"
      host        = "${self.public_ip}"
    }
   }

     user_data       = file("install_docker.sh")
   
}
 
 