provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Hello, World</h1>" > /var/www/html/index.html
              sudo systemctl enable httpd
              sudo systemctl start httpd
              EOF

  user_data_replace_on_change = true
  tags = {
    Name = "terraform-example"
  }
}
resource "aws_security_group" "web_server" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

