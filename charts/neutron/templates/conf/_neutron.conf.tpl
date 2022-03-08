# neutron.conf
[DEFAULT]
debug = {{ .Values.neutron_logging_debug }}

log_dir = /var/log/kolla/neutron

# NOTE(elemoine): set use_stderr to False or the logs will also be sent to
# stderr and collected by Docker
use_stderr = False
bind_host = 0.0.0.0

bind_port = {{ .Values.neutron_server_listen_port }}

api_paste_config = /etc/neutron/api-paste.ini

api_workers = 1
metadata_workers = 1
rpc_workers = 1
rpc_state_report_workers = 1

# NOTE(SamYaple): We must specify this value here rather than the metadata conf
# because it is used by the l3 and dhcp agents. The reason the path has 'kolla'
# in it is because we are sharing this socket in a volume which is it's own dir
metadata_proxy_socket = /var/lib/neutron/kolla/metadata_proxy

interface_driver = linuxbridge

allow_overlapping_ips = true

core_plugin = ml2
service_plugins = router

transport_url = rpc_transport_url

auth_strategy = noauth

{{- if .Values.enable_neutron_dvr -}}
router_distributed = True
{{- end -}}



[oslo_concurrency]
lock_path = /var/lib/neutron/tmp

[agent]
root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf

[database]
connection = mysql+pymysql://{{ .Values.neutron_database_user }}:database_password_placeholder@database_address_placeholder/{{ .Values.neutron_database_name }}
max_retries = -1


[privsep]
helper_command=sudo neutron-rootwrap /etc/neutron/rootwrap.conf privsep-helper
