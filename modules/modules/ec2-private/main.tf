resource "aws_instance" "backend" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.private_subnets[count.index]
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  provisioner "file" {
    source      = var.app_local_path
    destination = "/home/ubuntu/app"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.private_ip
      bastion_host        = var.bastion_ip
      bastion_user        = "ubuntu"
      bastion_private_key = file(var.private_key_path)
      timeout             = "2m"
    }
  }

  provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install -y python3-pip",
    "pip3 install flask",
    "cd /home/ubuntu/app",
    "nohup python3 app.py > app.log 2>&1 &",
    "sleep 5",  
    "curl -f http://localhost:5000 || (echo ' Flask did not start properly!' && exit 1)"
  ]

  connection {
    type                = "ssh"
    user                = "ubuntu"
    private_key         = file(var.private_key_path)
    host                = self.private_ip
    bastion_host        = var.bastion_ip
    bastion_user        = "ubuntu"
    bastion_private_key = file(var.private_key_path)
    timeout             = "2m"
  }
}


  tags = {
    Name = "backend-${count.index + 1}"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Allow internal access from proxy"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
