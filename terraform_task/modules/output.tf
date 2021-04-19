output "instance_Private-ips" {
  value = aws_instance.my-instance.*.private_ip
}

output "instance_Public-ips" {
  value = aws_instance.my-instance.*.public_ip
}