output "ip" {
  value = aws_instance.webec2.public_ip
}
output "state" {
  value = aws_instance.webec2.instance_state
}
output "ins_id" {
  value = aws_instance.webec2.id
}