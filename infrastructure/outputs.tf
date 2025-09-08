output "public_dns" {
  value = aws_instance.cicd_server.public_dns
}

output "ssh_connection" {
  value = "ssh -i /home/obito/.ssh/id_ed25519.pub ec2-user@${aws_instance.cicd_server.public_ip}"
}