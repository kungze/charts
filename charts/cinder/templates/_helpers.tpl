{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper cinder api image name
*/}}
{{- define "cinder.api.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderApi "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper cinder volume image name
*/}}
{{- define "cinder.volume.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderVolume "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper cinder scheduler image name
*/}}
{{- define "cinder.scheduler.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderScheduler "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper cinder backup image name
*/}}
{{- define "cinder.backup.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderBackup "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper tgtd image name
*/}}
{{- define "kolla.tgtd.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.tgtd "global" .Values.global) -}}
{{- end -}}
{{/*
Return the proper kolla toolbox image name
*/}}
{{- define "kolla.toolbox.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.kollaToolbox "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Kubernetes Entrypoint image name
*/}}
{{- define "entrypoint.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.entrypoint "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper cinder loop image name
*/}}
{{- define "cinder.loop.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderLoop "global" .Values.global) -}}
{{- end -}}

{{/*
Return the cinder.internal.endpoints
*/}}
{{- define "cinder.internal.endpoints" -}}
    {{- $internalService := .Values.service.publicService.name }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.service.cluster_domain_suffix }}
    {{- printf "http://%s.%s.svc.%s:%d/v3" $internalService $releaseNamespace $clusterDomain (.Values.service.publicService.port | int) }}
{{- end }}

{{/*
Return the cinder.public.endpoints
*/}}
{{- define "cinder.public.endpoints" -}}
    {{- $publicService := .Values.service.internalService.name }}
    {{- $publicPort := .Values.service.internalService.httpPort }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.service.cluster_domain_suffix }}
    {{- printf "http://%s.%s.svc.%s/v3" $publicService $releaseNamespace $clusterDomain }}
{{- end }}
