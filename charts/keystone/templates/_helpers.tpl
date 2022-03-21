{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Keystone image name
*/}}
{{- define "keystone.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.keystoneAPI "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Kubernetes Entrypoint image name
*/}}
{{- define "entrypoint.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.entrypoint "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Kolla toolbox image name
*/}}
{{- define "kolla.toolbox.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.kollaToolbox "global" .Values.global) -}}
{{- end -}}

{{/*
Return the keystone.internal.endpoints
*/}}
{{- define "keystone.internal.endpoints" -}}
{{- if not (empty .Values.endpoints.auth.admin) }}
    {{- $internalService := .Values.service.publicService.name }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.endpoints.cluster_domain_suffix }}
    {{- printf "http://%s.%s.svc.%s:%d/v3" $internalService $releaseNamespace $clusterDomain (.Values.service.publicService.port | int) }}
{{- end }}
{{- end }}

{{/*
Return the keystone.public.endpoints
*/}}
{{- define "keystone.public.endpoints" -}}
{{- if not (empty .Values.endpoints.auth.admin) }}
    {{- $publicService := .Values.service.internalService.name }}
    {{- $publicPort := .Values.service.internalService.httpPort }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.endpoints.cluster_domain_suffix }}
    {{- printf "http://%s.%s.svc.%s/v3" $publicService $releaseNamespace $clusterDomain }}
{{- end }}
{{- end }}
