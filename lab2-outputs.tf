output "Bigip1ManagementEipAddress" {
  value = aws_instance.bigip1.public_ip
}
output "Bigip2ManagementEipAddress" {
  value = aws_instance.bigip2.public_ip
}
output "bigip1_private_mgmt_address" {
  value = aws_instance.bigip1.private_ip
}
output "bigip2_private_mgmt_address" {
  value = aws_instance.bigip2.private_ip
}
output "bigip1_traffic-self" {
  value = aws_network_interface.bigip1_traffic.private_ips
}
output "bigip2_traffic-self" {
  value = aws_network_interface.bigip2_traffic.private_ips
}
output "f5_ami" {
  value = data.aws_ami.f5.id
}
output "virtual_server01_elastic_ip" {
  value = aws_eip.virtual_server01.public_ip
}
