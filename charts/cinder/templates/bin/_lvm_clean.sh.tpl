#!/bin/bash
set -ex
vgremove -y {{ .Values.conf.lvm.vg_name }}
pvremove {{ .Values.conf.lvm.loop_name }}
{{- if .Values.conf.lvm.create_loop_device }}
losetup -d {{ .Values.conf.lvm.loop_name }}
{{- end }}
