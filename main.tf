resource "aws_instance" "ec2" { 
  instance_type = "t2.micro"
  ami           = "ami-0574da719dca65348" 

     user_data       = file("install_docker.sh")

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("/home/nobel_lavagna.pem")}"
      host        = "${self.public_ip}"
    }
   provisioner "file" {
        source      = "./docker-compose-ec2.yml"
        destination = "/home/ubuntu/docker-compose.yml"
       

   }
    provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu",
      "sudo docker-compose -p ts up -d --wait",
    ]

    } 
}
 
 