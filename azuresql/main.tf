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
  location = "East US"
}

resource "azurerm_mysql_server" "mysql_server" {
  name                = "Azure-mysql-server"
  location            = azurerm_resource_group.azure_group.location
  resource_group_name = azurerm_resource_group.azure_group.name
  sku_name            = "B_Gen5_1"
  version             = "5.7"
  storage_mb          = 5120  # 5 GB

  administrator_login          = var.mysql_admin_username
  administrator_login_password = var.mysql_admin_password

  tags = {
    environment = "production"
  }

  ssl_enforcement_enabled = true  # Enable SSL enforcement for secure connections

  # Configure backup retention
  backup {
    retention_days = 7
    geo_redundant_backup_enabled = false
  }

  # Define a firewall rule to allow all Azure services to access the server
  firewall_rule {
    name                        = "AllowAllWindowsAzureIps"
    start_ip_address            = "0.0.0.0"
    end_ip_address              = "0.0.0.0"
  }

  # Define a firewall rule to allow specific IP addresses
  # Replace "x.x.x.x" and "y.y.y.y" with actual IP addresses or ranges
  firewall_rule {
    name                        = "AllowFromSpecificIPs"
    start_ip_address            = "0.0.0.0"
    end_ip_address              = "0.0.0.0"
  }
}