{{- define "common.manifests.job_update_conn_info" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $connInfoSecretName := index . "connInfoSecretName" -}}
{{- $podEnvVars := index . "podEnvVars" | default false -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceName "update-openstack-conn-info" | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
spec:
  template:
    spec:
      containers:
        - name: {{ printf "%s-%s" $serviceName "update-openstack-conn-info" | quote }}
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.kollaToolbox "global" $envAll.Values.global) | quote }}
          imagePullPolicy: {{ $envAll.Values.global.pullPolicy }}
          command:
            - /bin/sh
            - -c
            - python3 /tmp/update-openstack-conn-info.py
          env:
            - name: KUBERNETES_NAMESPACE
              value: {{ $envAll.Release.Namespace }}
            - name: CONN_INFO_SECRET_NAME
              value: {{ $connInfoSecretName | quote }}
{{- if $podEnvVars }}
{{ $podEnvVars | toYaml | indent 12 }}
{{- end }}
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /tmp/update-openstack-conn-info.py
              name: {{ $configMapBin | quote }}
              subPath: update-openstack-conn-info.py
      restartPolicy: OnFailure
      serviceAccount: {{ $envAll.Values.serviceAccountName}}
      serviceAccountName: {{ $envAll.Values.serviceAccountName}}
      volumes:
      - emptyDir: {}
        name: pod-tmp
      - configMap:
          defaultMode: 0755
          name: {{ $configMapBin | quote }}
        name: {{ $configMapBin | quote }}
{{- end }}
