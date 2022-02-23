{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name for RabbitMQ subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openstack.rabbitmq.fullname" -}}
{{- if .Values.rabbitmq.fullnameOverride -}}
{{- .Values.rabbitmq.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "rabbitmq" .Values.rabbitmq.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ host
*/}}
{{- define "openstack.rabbitmqHost" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomainSuffix }}
    {{- printf "%s.%s.svc.%s" (include "openstack.rabbitmq.fullname" .) $releaseNamespace $clusterDomain -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ port
*/}}
{{- define "openstack.rabbitmqPort" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "%d" (.Values.rabbitmq.service.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Keystone image name
*/}}
{{- define "rabbitmq.connInfo" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- $rabbitmqHost := include "openstack.rabbitmqHost" . }}
    {{- $rabbitmqUser := .Values.rabbitmq.auth.username }}
    {{- $rabbitmqPassword := (index .Values "gen-password" "passwordEnvs" "rabbitmq-password" | b64dec) }}
    {{- $rabbitmqPort := (include "openstack.rabbitmqPort" . | int) }}
    {{- printf "rabbit://%s:%s@%s:%d" $rabbitmqUser $rabbitmqPassword $rabbitmqHost $rabbitmqPort }}
{{- end }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openstack.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the Mariadb host
*/}}
{{- define "openstack.mariadbHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomainSuffix }}
    {{- printf "%s.%s.svc.%s" (include "openstack.mariadb.fullname" .) $releaseNamespace $clusterDomain -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "openstack.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- end -}}
{{- end -}}

{{/*
Return the mariadb connInfo
*/}}
{{- define "mariadb.connInfo" -}}
{{- if .Values.mariadb.enabled }}
    {{- $mariadbHost := include "openstack.mariadbHost" . }}
    {{- $mariadbPort := (include "openstack.databasePort" . | int) }}
    {{- printf "%s:%d" $mariadbHost $mariadbPort }}
{{- end }}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openstack.memcached.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "memcached" "chartValues" .Values.memcached "context" $) -}}
{{- end -}}

{{/*
Return the Memcached Hostname
*/}}
{{- define "openstack.cacheHost" -}}
{{- if .Values.memcached.enabled }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomainSuffix }}
    {{- printf "%s.%s.svc.%s" (include "openstack.memcached.fullname" .) $releaseNamespace $clusterDomain -}}
{{- end -}}
{{- end -}}

{{/*
Return the Memcached Port
*/}}
{{- define "openstack.cachePort" -}}
{{- if .Values.memcached.enabled }}
    {{- printf "11211" -}}
{{- end -}}
{{- end -}}

{{/*
Return the memcached connInfo
*/}}
{{- define "memcached.connInfo" -}}
{{- if .Values.memcached.enabled }}
    {{- $memcachedHost := include "openstack.cacheHost" . }}
    {{- $memcachedPort := (include "openstack.cachePort" . | int) }}
    {{- printf "%s:%d" $memcachedHost $memcachedPort }}
{{- end }}
{{- end -}}
