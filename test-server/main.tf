resource "aws_eip" "eip1" {
  instance = aws_instance.test-server.id
  vpc      = true
}
resource "aws_instance" "test-server" {
  ami           = "ami-00c39f71452c08778" 
  instance_type = "t2.micro"
  key_name = "ubuntu-keypair"
  vpc_security_group_ids= ["sg-09ab4eda7c57a0d8b"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./ubuntu-keypair.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
 provisioner "local-exec" {

        command = " echo ${aws_instance.test-server.public_ip} > inventory "
 }
 
 provisioner "local-exec" {
 command = "ansible-playbook test-bank-playbook.yml "
  } 
}

output "test-server_public_ip" {

  value = aws_instance.test-server.public_ip
  
}