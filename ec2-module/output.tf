output "vm_ips" {
  value=[for vm in aws_instance.instance : vm.private_ip]
}