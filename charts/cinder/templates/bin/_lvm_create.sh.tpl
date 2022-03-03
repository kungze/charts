#!/bin/bash
set -ex
pvcreate {{ .Values.conf.lvm.loop_name }}
vgcreate {{ .Values.conf.lvm.vg_name }} {{ .Values.conf.lvm.loop_name }}
