# ml2_conf.ini
[ml2]
# Changing type_drivers after bootstrap can lead to database inconsistencies
type_drivers = flat,vlan
tenant_network_types = vlan
mechanism_drivers = linuxbridge
extension_drivers = port_security

[ml2_type_vlan]
network_vlan_ranges = physnet1

[ml2_type_flat]
flat_networks = *
