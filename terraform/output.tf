output "Jenkins_IP" {
  description = "Jenkins private ip"
  value       = "${module.Jenkins.private_ip}"
}
output "Jenkins_Public_IP" {
  description = "Jenkins public ip"
  value       = "${module.Jenkins.public_ip}"
}

output "UMSL_IP" {
  description = "UMSL private ip"
  value       = "${module.umsl.private_ip}"
}

output "UMSL_Public_IP" {
  description = "UMSL Public ip"
  value       = "${module.umsl.public_ip}"
}