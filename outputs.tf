output "sonarqube_url" {
  description = "SonarQube URL"
  value       = "http://${module.sonarqube.sonar_lb_dns_name}"
}
