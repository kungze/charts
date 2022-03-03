[DEFAULT]
debug = False
log_dir = /var/log/kolla/cinder
use_forwarded_for = true
use_stderr = False
osapi_volume_workers = 5
volume_name_template = volume-%s
volumes_dir = /var/lib/cinder/volumes
os_region_name = {{ .Values.endpoints.auth.cinder.region_name }}

{{- if and .Values.conf.lvm.enabled .Values.conf.ceph.enabled }}
enabled_backends = {{ printf "%s,%s" (.Values.conf.lvm.volume_type) (.Values.conf.ceph.volume_type) }}
default_volume_type = {{ .Values.conf.ceph.volume_type }}
{{- else if .Values.conf.lvm.enabled }}
enabled_backends = {{ .Values.conf.lvm.volume_type }}
default_volume_type = {{ .Values.conf.lvm.volume_type }}
{{- else if .Values.conf.ceph.enabled }}
enabled_backends = {{ .Values.conf.ceph.volume_type }}
default_volume_type = {{ .Values.conf.ceph.volume_type }}
{{- end }}

{{- if .Values.conf.backup.anabled }}
backup_driver = cinder.backup.drivers.ceph.CephBackupDriver
backup_ceph_conf = /etc/ceph/ceph.conf
backup_ceph_user = {{ .Values.conf.backup.backup_user }}
backup_ceph_chunk_size = 134217728
backup_ceph_pool = {{ .Values.conf.backup.backup_pool_name }}
backup_ceph_stripe_unit = 0
backup_ceph_stripe_count = 0
restore_discard_excess_bytes = true
{{- end }}

osapi_volume_listen = 0.0.0.0
osapi_volume_listen_port = {{ .Values.service.publicService.port }}
api_paste_config = /etc/cinder/api-paste.ini
auth_strategy = keystone
transport_url = rabbitmq_server_placeholder
enable_force_upload = True
verify_glance_signatures = disabled
random_select_backend = True

{{- if .Values.conf.ceph.enabled }}
random_select_backend = True
{{- end }}

[oslo_messaging_notifications]
transport_url = rabbitmq_server_placeholder
{{- if .Values.conf.enabled_notification_topics }}
driver = messagingv2
topics = notifications
{{- else }}
driver = noop
{{- end }}

[oslo_middleware]
enable_proxy_headers_parsing = True

[database]
connection = mysql+pymysql://cinder:database_password_placeholder@database_host_placeholder/cinder
connection_recycle_time = 10
max_pool_size = 1
max_retries = -1

[keystone_authtoken]
www_authenticate_uri = keystone_auth_url_placeholder
auth_url = keystone_auth_url_placeholder
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = {{ .Values.endpoints.auth.cinder.username }}
password = cinder_keystone_password_placeholder
memcached_servers = memcache_server_placeholder

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp

[privsep_entrypoint]
helper_command = sudo cinder-rootwrap /etc/cinder/rootwrap.conf privsep-helper --config-file /etc/cinder/cinder.conf

{{- if .Values.conf.ceph.enabled }}
[{{ .Values.conf.ceph.volume_type }}]
volume_driver = cinder.volume.drivers.rbd.RBDDriver
volume_backend_name = {{ .Values.conf.ceph.volume_type }}
rbd_pool = {{ .Values.conf.ceph.pool_name }}
rbd_ceph_conf = /etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot = false
rbd_max_clone_depth = 5
rbd_store_chunk_size = 4
rados_connect_timeout = 5
rbd_user = {{ .Values.conf.ceph.rbd_user }}
rbd_secret_uuid = {{ .Values.conf.ceph.rbd_secret_uuid }}
report_discard_supported = True
image_upload_use_cinder_backend = False
{{- end }}

{{- if .Values.conf.lvm.enabled }}
[{{ .Values.conf.lvm.volume_type }}]
volume_group = {{ .Values.conf.lvm.vg_name }}
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_backend_name = {{ .Values.conf.lvm.volume_type }}
target_helper = {{ .Values.conf.lvm.lvm_target_helper }}
target_protocol = iscsi
{{- end }}
