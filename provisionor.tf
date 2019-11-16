# The local-exec provisioner executes a command locally on the machine running Terraform.
# Another useful provisioner is remote-exec which invokes a script on a remote resource after it is created.
# https://www.terraform.io/docs/provisioners/index.html

## Option 1
resource "aws_instance" "example" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

## Option 2
resource "aws_key_pair" "example" {
  key_name = "examplekey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web" {
  key_name = aws_key_pair.example.key_name
  # ...

 connection {
    type     = "ssh"
    user     = "root"
    private_key = file("~/.ssh/id_rsa")
    host     = self.ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }