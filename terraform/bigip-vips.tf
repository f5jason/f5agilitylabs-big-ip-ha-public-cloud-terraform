### Elastic (Public) IP Address Assignments for Virtual Servers

resource "aws_eip" "vip1" {
  vpc                       = true
  network_interface         = aws_network_interface.bigip1_external.id
  associate_with_private_ip = var.bigip_netcfg["bigip1"]["app_vips"][0]

  tags = {
    f5_cloud_failover_label = "example01"
    VIPS                    = "${var.bigip_netcfg["bigip1"]["app_vips"][0]},${var.bigip_netcfg["bigip2"]["app_vips"][0]}"
  }
}


output "vip1_public_ip" {
  value = aws_eip.vip1.public_ip
}
