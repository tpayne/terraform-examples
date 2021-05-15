output "load_balancer_private_ip_address" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].private_ip_address
}

output "load_balancer_backend_address_pool" {
  value = {
    name = azurerm_lb_backend_address_pool.lb.name
    id   = azurerm_lb_backend_address_pool.lb.id
  }
}
