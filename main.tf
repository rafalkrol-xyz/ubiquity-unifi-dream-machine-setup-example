resource "unifi_network" "network" {
  for_each     = var.networks
  name         = each.key
  purpose      = "corporate"
  subnet       = "192.168.${2 + index(keys(var.networks), each.key)}.0/24"
  vlan_id      = (2 + index(keys(var.networks), each.key)) * 100
  dhcp_start   = "192.168.${2 + index(keys(var.networks), each.key)}.6"
  dhcp_stop    = "192.168.${2 + index(keys(var.networks), each.key)}.254"
  dhcp_enabled = true
}

data "unifi_wlan_group" "default" {
}

data "unifi_user_group" "default" {
}

resource "unifi_wlan" "wifi" {
  for_each      = var.networks
  name          = "${var.basename}_${unifi_network.network[each.key].name}"
  vlan_id       = unifi_network.network[each.key].vlan_id
  passphrase    = each.value
  wlan_group_id = data.unifi_wlan_group.default.id
  user_group_id = data.unifi_user_group.default.id
  security      = "wpapsk"
}

# The below group was created to adopt "Option 2: Block all VLANs to one another" from the following Unifi's guide: https://help.ui.com/hc/en-us/articles/115010254227-UniFi-USG-Firewall-How-to-Disable-InterVLAN-Routing
resource "unifi_firewall_group" "no_inter_vlan" {
  name    = "RFC1918"
  type    = "address-group"
  members = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

resource "unifi_firewall_rule" "drop_all" {
  name                   = "DenyInterVLANTraffic"
  action                 = "drop"
  ruleset                = "LAN_IN"
  rule_index             = 2001
  protocol               = "all"
  src_firewall_group_ids = [unifi_firewall_group.no_inter_vlan.id]
  dst_firewall_group_ids = [unifi_firewall_group.no_inter_vlan.id]
}
