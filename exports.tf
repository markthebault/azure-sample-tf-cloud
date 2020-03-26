resource "local_file" "kubectl" {
  content  = azurerm_kubernetes_cluster.k8s.kube_config_raw
  filename = "${path.module}/kubectl.conf"
}


output "kubecfg" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
}
