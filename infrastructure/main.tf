provider "aws" {
  region = "ap-south-1" # You can change to your preferred region
}

# Create a key pair for EC2 instance
resource "aws_key_pair" "cicd_key" {
  key_name   = "cicd-keypair"
  public_key = file("/home/obito/.ssh/id_ed25519.pub") # Replace with your public key path
}

# Create security group for EC2 instance
resource "aws_security_group" "cicd_sg" {
  name        = "cicd-security-group"
  description = "Security group for CI/CD server"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins access
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cicd-security-group"
  }
}

# --- Dynamic AMI Lookup (fixes region issue) ---
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create EC2 instance
resource "aws_instance" "cicd_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.cicd_key.key_name
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  
  # User data to install Docker and Jenkins on instance launch
  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo amazon-linux-extras install docker -y
            sudo service docker start
            sudo usermod -a -G docker ec2-user

            # Install Jenkins
            sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
            sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

            # Remove default Java 11
            sudo yum remove -y java-11-openjdk

            # Enable and install Amazon Corretto 17
            sudo amazon-linux-extras enable corretto17
            sudo yum install -y java-17-amazon-corretto-devel

            # Install Jenkins
            sudo yum install -y jenkins
            sudo usermod -a -G docker jenkins

            # Start Jenkins
            sudo systemctl start jenkins
            sudo systemctl enable jenkins

            # Pull and run your Docker Hub image
            docker run -d -p 8081:80 iwaseemdevops/static-cicd:1.0
            EOF
  tags = {
    Name = "cicd-website-server"
  }
}

# Output the public IP address of the instance
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.cicd_server.public_ip
}

# Output the Jenkins URL
output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.cicd_server.public_ip}:8080"
}