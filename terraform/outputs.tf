output "controller_ip" {
  value = aws_instance.controller.public_ip
}

output "agent_ip" {
  value = aws_instance.agent.public_ip
}
