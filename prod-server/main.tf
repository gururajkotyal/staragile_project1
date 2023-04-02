resource "aws_eip" "eip1" {
  vpc      = true
}
resource "aws_instance" "prod-server" {
  ami           = "ami-00c39f71452c08778" 
  instance_type = "t2.micro"
  key_name = "DEMOKEY"
  vpc_security_group_ids= ["sg-0c7aae9017fc5106b"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./DEMOKEY.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "prod-server"
  }
 provisioner "local-exec" {

        command = " echo ${aws_instance.prod-server.public_ip} > inventory "
 }
 
 provisioner "local-exec" {
 command = "ansible-playbook prod-bank-playbook.yml "
  } 
}

output "prod-server_public_ip" {

  value = aws_instance.prod-server.public_ip
  
}