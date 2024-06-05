variable "mysql_admin_username" {
  description = "MySQL admin username"
}

variable "mysql_admin_password" {
  description = "MySQL admin password"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azure_group" {
  name     = "nodeproject_group"
  location = "Australia East"
}

 resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                = "nodeprojectmysql"
  location            = azurerm_resource_group.azure_group.location
  resource_group_name = azurerm_resource_group.azure_group.name
  sku_name               = "GP_Standard_D2ds_v4"
  administrator_login          = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  tags = {
    environment = "production"
  }
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_eks_node_1" {
  name                = "AllowEKSNode1"
  resource_group_name = azurerm_resource_group.azure_group.name
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  start_ip_address    = "0.0.0.0"  # Replace with actual IP
  end_ip_address      = "0.0.0.0"  # Replace with actual IP
}
