resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file("mykey.pub")
}

resource "aws_instance" "dove-inst" {
  ami               = var.AMIS[var.REGION]
  instance_type     = "t2.micro"
  availability_zone = var.ZONE1
  key_name          = aws_key_pair.dove-key.key_name
  tags = {
    Name    = "Dove-Instance"
    Project = "Dove"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("mykey")
    host        = self.public_ip
  }
}
