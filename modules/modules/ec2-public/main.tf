resource "aws_instance" "proxy" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnets[count.index]
  key_name      = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.proxy_sg.id]

    provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install -y nginx",
    "sudo bash -c 'echo \"server {\n    listen 80;\n    location / {\n        proxy_pass http://${var.internal_alb_dns_name}:5000;\n        proxy_set_header Host \\$host;\n        proxy_set_header X-Real-IP \\$remote_addr;\n        proxy_set_header X-Forwarded-For \\$proxy_add_x_forwarded_for;\n        proxy_set_header X-Forwarded-Proto \\$scheme;\n    }\n}\" > /etc/nginx/sites-available/default'",
    "sudo systemctl restart nginx"
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
}


  tags = {
    Name = "proxy-${count.index + 1}"
  }
}

resource "aws_security_group" "proxy_sg" {
  name        = "proxy-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = var.vpc_id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}