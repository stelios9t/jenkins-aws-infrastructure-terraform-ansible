provider "aws" {
  region = "eu-central-1"
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = file("${path.module}/../keys/jenkins-key.pub")
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins UI"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
# as shown in cidr blocks ingress is available from all IPs, which is not ideal
# ideally jenkins should be placed in a private subnet with tighter security controls, but for the purpose of this project and not using a NAT gateway to increase costs cidr range will remain to all access
# See private subnet implementation at the bottom
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "controller" {
  ami           = "ami-080e1f13689e07408" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.jenkins_key.key_name
  security_groups = [aws_security_group.jenkins_sg.name]
  tags = {
    Name = "Jenkins-Controller"
  }
}

resource "aws_instance" "agent" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.jenkins_key.key_name
  security_groups = [aws_security_group.jenkins_sg.name]
  tags = {
    Name = "Jenkins-Agent"
  }
}



# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "private_subnet" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.1.0/24"
# prevents EC2 instances from getting a public IP in this subnet
#   map_public_ip_on_launch = false
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public_subnet.id
# }

# Route for all workloads in private subnets to access the internet through the NAT gateway
# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }
# }

# resource "aws_route_table_association" "private_assoc" {
#   subnet_id      = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.private_rt.id
# }
