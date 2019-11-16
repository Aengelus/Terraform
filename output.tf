# apply highlights the outputs. You can also query the outputs after apply-time using terraform output
# Define an output
output "ip" {
  value = aws_eip.ip.public_ip
}