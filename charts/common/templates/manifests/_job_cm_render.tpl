{{- define "common.manifests.job_cm_render" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $jobAnnotations := index . "jobAnnotations" -}}
{{- $dbUserPasswordName := index . "dbUserPasswordName" -}}
{{- $podEnvVars := index . "podEnvVars" | default false -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc" ) -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceName "cm-render" | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
  annotations:
{{- if $jobAnnotations }}
{{ toYaml $jobAnnotations | indent 4 }}
{{- end }}
spec:
  template:
    spec:
      containers:
        - name: {{ printf "%s-%s" $serviceName "cm-render" | quote }}
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.kollaToolbox "global" $envAll.Values.global) | quote }}
          imagePullPolicy: {{ $envAll.Values.global.pullPolicy }}
          command:
            - /bin/sh
            - -c
            - python3 /tmp/configmap-render.py
          env:
            - name: KUBERNETES_NAMESPACE
              value: {{ $envAll.Release.Namespace }}
            - name: CONFIG_MAP_NAME
              value: {{ printf "%s-%s" $serviceName "etc" | quote }}
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: {{ $dbUserPasswordName | quote }}
                  name: {{ index $envAll.Values "openstack-dep" "passwordSecretName" }}
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  key: DATABASE_URL
                  name: {{ index $envAll.Values "openstack-dep" "connInfoSecret" }}
            - name: RABBITMQ_URL
              valueFrom:
                secretKeyRef:
                  key: RABBITMQ_URL
                  name: {{ index $envAll.Values "openstack-dep" "connInfoSecret" }}
            - name: MEMCACHE_URL
              valueFrom:
                secretKeyRef:
                  key: MEMCACHE_URL
                  name: {{ index $envAll.Values "openstack-dep" "connInfoSecret" }}
{{- if $podEnvVars }}
{{ $podEnvVars | toYaml | indent 12 }}
{{- end }}
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /tmp/configmap-render.py
              name: {{ $configMapBin | quote }}
              subPath: configmap-render.py
            - mountPath: /etc/sudoers.d/kolla_ansible_sudoers
              name: {{ $configMapEtc | quote }}
              subPath: kolla-toolbox-sudoer
      initContainers:
        - name: init
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.entrypoint "global" $envAll.Values.global) | quote }}
          imagePullPolicy: {{ $envAll.Values.global.pullPolicy }}
          command:
            - kubernetes-entrypoint
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.name
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.namespace
            - name: PATH
              value: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/
            - name: DEPENDENCY_JOBS
              value: {{ include "common.utils.joinListWithComma" $envAll.Values.dependencies.cm_render.jobs }}
            {{- if index  $envAll.Values "openstack-dep" "enabled" }}
            - name: DEPENDENCY_SERVICE
              value: {{ $envAll.Release.Namespace }}:{{ $envAll.Release.Name }}-mariadb
            {{- end }}
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
      - configMap:
          defaultMode: 0644
          name: {{ $configMapEtc | quote }}
        name: {{ $configMapEtc | quote }}
{{- end }}
