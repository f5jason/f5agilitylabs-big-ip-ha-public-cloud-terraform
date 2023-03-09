output "AWS_PASSWORD" {
  value = var.AWS_PASSWORD
}
output "AWS_USER" {
  value = var.AWS_USER
}
output "AWS_CONSOLE_LINK" {
  value = var.AWS_CONSOLE_LINK
}
output "elb_dns_name" {
  value = aws_elb.example.dns_name
}
output "web1_address" {
  value = aws_instance.example-a.private_ip
}
output "web2_address" {
  value = aws_instance.example-b.private_ip
}
