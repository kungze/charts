{{- define "common.scripts.db_init" -}}
#!/bin/bash
set -ex
sudo /opt/ansible/bin/ansible localhost -m mysql_db \
    -a "login_host=$DB_HOST_NAME login_port=$DB_PORT login_user=root login_password=$DB_ROOT_PASSWORD name=$DB_NAME"
sudo /opt/ansible/bin/ansible localhost -m mysql_user \
    -a "login_host=$DB_HOST_NAME login_port=$DB_PORT login_user=root login_password=$DB_ROOT_PASSWORD name=$DB_NAME password=$DB_USER_PASSWORD host=% priv=$DB_NAME.*:ALL append_privs=yes"
{{- end -}}
