resource "aws_instance" "web" {
  ami                    = "ami-03f4878755434977f"     
  instance_type          = "t2.large"    
  key_name               = "Swiggy"        
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]
  user_data              = file("install.sh")

  tags = {
    Name = "Jenkins-SonarQube"
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-SG"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-SG"
  }
}