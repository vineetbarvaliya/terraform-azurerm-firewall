locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }
  name_prefix   = var.name_prefix != "" ? replace(var.name_prefix, "/[0-9a-z]$/", "$0-") : ""
  firewall_name = coalesce(var.custom_firewall_name, "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-firewall")

  #Name of the subnet attached to the firewall. NOTE The Subnet used for the Firewall must have the name AzureFirewallSubnet and the subnet mask must be at least /26. Source: https://www.terraform.io/docs/providers/azurerm/r/firewall.html
  firewall_subnet_name = "AzureFirewallSubnet"

  #Allocation method of the firewall's public ip. Note: The Public IP must have a Static allocation and Standard sku. Source: https://www.terraform.io/docs/providers/azurerm/r/firewall.html#public_ip_address_id
  public_ip_allocation_method = "Static"

  #Sku of the firewall's public ip. Note: The Public IP must have a Static allocation and Standard sku. Source: https://www.terraform.io/docs/providers/azurerm/r/firewall.html#public_ip_address_id
  public_ip_sku = "Standard"

  public_ip_name = coalesce(var.public_ip_custom_name, "fw-${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-pip")

  logs_destinations_ids             = var.logs_destinations_ids == null ? [] : var.logs_destinations_ids
  log_analytics_id                  = coalescelist([for r in local.logs_destinations_ids : r if contains(split("/", lower(r)), "microsoft.operationalinsights")], [null])[0]
  log_analytics_subscription_id     = try(split("/", local.log_analytics_id)[2], null)
  log_analytics_resource_group_name = try(split("/", local.log_analytics_id)[4], null)
  log_analytics_name                = try(split("/", local.log_analytics_id)[8], null)

}
