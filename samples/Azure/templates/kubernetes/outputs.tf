/**
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

output "kubernetes-id" {
  description = "K8s Id"
  value       = azurerm_kubernetes_cluster.k8s_server.id
}

output "kubernetes-pod-cidr" {
  description = "K8s POD cidr"
  value       = azurerm_kubernetes_cluster.k8s_server.network_profile[0].pod_cidr
}

output "kubernetes-service-cidr" {
  description = "K8s Service cidr"
  value       = azurerm_kubernetes_cluster.k8s_server.network_profile[0].service_cidr
}

output "kubernetes-dns-service-ip" {
  description = "K8s DNS service ip"
  value       = azurerm_kubernetes_cluster.k8s_server.network_profile[0].dns_service_ip
}

output "kubernetes-fqdn" {
  description = "K8s Fully qualified domain name"
  value       = azurerm_kubernetes_cluster.k8s_server.fqdn
}

output "kubernetes-config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.k8s_server.kube_config_raw
}

output "kubernetes-client-key" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.k8s_server.kube_config.0.client_key
}

output "kubernetes-client-cert" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.k8s_server.kube_config.0.client_certificate
}

output "kubernetes-cluster-ca-cert" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.k8s_server.kube_config.0.cluster_ca_certificate
}

output "kubernetes-host" {
  sensitive   = true
  description = "K8s hostname"
  value       = azurerm_kubernetes_cluster.k8s_server.kube_config.0.host
}

