# Cinder Charts

cinder charts 用来安装 openstack cinder 服务。该 charts 支持 lvm、ceph 两种后端类型。

## Parameters

### Global parameters

| Name                   | Form title | Description                                  | Value          |
| ---------------------- | ---------- | -------------------------------------------- | -------------- |
| `global.imageRegistry` |            | Global Docker image registry                 | `docker.io`    |
| `global.storageClass`  |            | Global StorageClass for Persistent Volume(s) | `""`           |
| `global.imageTag`      |            | Global docker image tag                      | `xena`         |
| `global.pullPolicy`    |            | Global image pull policy                     | `IfNotPresent` |


### Common parameters

| Name                                                   | Form title     | Description                                                              | Value                |
| ------------------------------------------------------ | -------------- | ------------------------------------------------------------------------ | -------------------- |
| `replicaCount`                                         |                | Number of cinder replicas to deploy (requires ReadWriteMany PVC support) | `1`                  |
| `serviceAccountName`                                   |                | ServiceAccount name                                                      | `cinder`             |
| `resources.limits`                                     |                | The resources limits for the Controller container                        | `{}`                 |
| `resources.requests`                                   |                | The requested resources for the Controller container                     | `{}`                 |
| `podSecurityContext.enabled`                           |                | Enabled cinder pods' Security Context                                    | `true`               |
| `podSecurityContext.runAsUser`                         |                | Set cinder pods' Security Context runAsUser                              | `0`                  |
| `containerSecurityContext.enabled`                     |                | Enabled cinder containers' Security Context                              | `true`               |
| `containerSecurityContext.runAsUser`                   |                | Set cinder containers' Security Context runAsUser                        | `0`                  |
| `lvmcontainerSecurityContext.enabled`                  |                | Enabled cinder lvm containers' Security Context                          | `true`               |
| `lvmcontainerSecurityContext.privileged`               |                | Switch cinder lvm containers' privilege possibility on or off            | `true`               |
| `lvmcontainerSecurityContext.runAsUser`                |                | Set cinder lvm containers' Security Context runAsUser                    | `0`                  |
| `lvmcontainerSecurityContext.allowPrivilegeEscalation` |                | Switch cinder lvm containers' privilegeEscalation possibility on or off  | `true`               |
| `livenessProbe.enabled`                                |                | Enable livenessProbe                                                     | `true`               |
| `livenessProbe.tcpSocket.port`                         |                | Port for livenessProbe                                                   | `8776`               |
| `livenessProbe.initialDelaySeconds`                    |                | Initial delay seconds for livenessProbe                                  | `30`                 |
| `livenessProbe.periodSeconds`                          |                | Period seconds for livenessProbe                                         | `10`                 |
| `livenessProbe.timeoutSeconds`                         |                | Timeout seconds for livenessProbe                                        | `1`                  |
| `livenessProbe.failureThreshold`                       |                | Failure threshold for livenessProbe                                      | `3`                  |
| `livenessProbe.successThreshold`                       |                | Success threshold for livenessProbe                                      | `1`                  |
| `readinessProbe.enabled`                               |                | Enable readinessProbe                                                    | `true`               |
| `readinessProbe.tcpSocket.port`                        |                | Port for readinessProbe                                                  | `8776`               |
| `readinessProbe.periodSeconds`                         |                | Period seconds for readinessProbe                                        | `10`                 |
| `readinessProbe.timeoutSeconds`                        |                | Timeout seconds for readinessProbe                                       | `1`                  |
| `readinessProbe.failureThreshold`                      |                | Failure threshold for readinessProbe                                     | `3`                  |
| `readinessProbe.successThreshold`                      |                | Success threshold for readinessProbe                                     | `1`                  |
| `customLivenessProbe`                                  |                | Override default liveness probe                                          | `{}`                 |
| `customReadinessProbe`                                 |                | Override default readiness probe                                         | `{}`                 |
| `lifecycle`                                            |                | LifecycleHooks to set additional configuration at startup                | `""`                 |


### cinder Image parameters

| Name                               | Form title | Description                                           | Value                                  |
| ---------------------------------- | ---------- | ----------------------------------------------------- | -------------------------------------- |
| `image.cinderApi.repository`       |            | cinderApi image repository                            | `kolla/ubuntu-binary-cinder-api`       |
| `image.cinderVolume.repository`    |            | cinderVolume image repository                         | `kolla/ubuntu-binary-cinder-volume`    |
| `image.cinderScheduler.repository` |            | cinderScheduler image repository                      | `kolla/ubuntu-binary-cinder-scheduler` |
| `image.cinderBackup.repository`    |            | cinderBackup image repository                         | `kolla/ubuntu-binary-cinder-backup`    |
| `image.dbSync.repository`          |            | dbSync image repository                               | `kolla/ubuntu-binary-cinder-api`       |
| `image.kollaToolbox.repository`    |            | kollaToolbox image repository                         | `kolla/ubuntu-binary-kolla-toolbox`    |
| `image.entrypoint.registry`        |            | entrypoint image registry                             | `quay.io`                              |
| `image.entrypoint.repository`      |            | entrypoint image repository                           | `airshipit/kubernetes-entrypoint`      |
| `image.entrypoint.tag`             |            | entrypoint image tag                                  | `v1.0.0`                               |
| `image.cinderLoop.repository`      |            | cinderLoop image repository                           | `docker/loop`                          |
| `image.cinderLoop.tag`             |            | cinderLoop image tag (immutable tags are recommended) | `latest`                               |


### Cinder config file

| Name                               | Form title | Description                                              | Value                     |
| ---------------------------------- | ---------- | -------------------------------------------------------- | ------------------------- |
| `conf.kolla_log_dir`               |            | 存放 kolla 日志文件的目录                                         | `/var/log/kolla/cinder`   |
| `conf.enabled_notification_topics` |            | 是否开启 notification                                        | `false`                   |
| `conf.lvm.enabled`                 |            | 是否对接 lvm 后端                                              | `true`                    |
| `conf.lvm.create_loop_device`      |            | 是否创建 loop 设备                                             | `true`                    |
| `conf.lvm.loop_name`               |            | loop 设备名称                                                | `/dev/loop0`              |
| `conf.lvm.dd_lvm_bs`               |            | loop 设备块大小                                               | `1M`                      |
| `conf.lvm.dd_lvm_count`            |            | loop 设备写次数                                               | `2048`                    |
| `conf.lvm.vg_name`                 |            | lvm 创建的卷组名称                                              | `cinder-volumes`          |
| `conf.lvm.volume_type`             |            | lvm 后端卷类型                                                | `lvm1`                    |
| `conf.ceph.enabled`                |            | 是否对接 ceph 后端                                             | `false`                   |
| `conf.ceph.volume_type`            |            | ceph 后端卷类型                                               | `rbd1`                    |
| `conf.ceph.pool_name`              |            | ceph 池名称                                                 | `volumes`                 |
| `conf.ceph.rbd_user`               |            | ceph 用户名                                                 | `admin`                   |
| `conf.ceph.rbd_secret_uuid`        |            | ceph secret uuid                                         | `""`                      |
| `conf.ceph.size`                   |            | ceph pool 副本数                                            | `1`                       |
| `conf.ceph.poolFailureDomain`      |            | ceph pool 失败域                                            | `host`                    |
| `conf.ceph.rook_namespace`         |            | rook-ceph 命名空间                                           | `rook-ceph`               |
| `conf.ceph.rook_cm_name`           |            | rook-ceph 配置信息的 configmap 名称                             | `rook-ceph-mon-endpoints` |
| `conf.ceph.rook_secret_name`       |            | rook-ceph 密钥相关的 secrets 名称                               | `rook-ceph-mon`           |
| `conf.ceph.ceph_username_fields`   |            | rook-ceph secrets 配置中的 username 字段                       | `ceph-username`           |
| `conf.ceph.ceph_secret_fields`     |            | rook-ceph secrets 配置中的 keyring 字段                        | `ceph-secret`             |
| `conf.ceph.ceph_cm_name`           |            | ceph configmap 名称 读取rook-ceph命名空间中的 configmap 注册到自己的命名空间 | `ceph-mon-endpoints`      |
| `conf.ceph.ceph_secret_name`       |            | ceph secrets 名称 读取rook-ceph命名空间中的 secret 注册到自己的命名空间      | `ceph-mon`                |
| `conf.backup.enabled`              |            | 是否对接 ceph backup                                         | `false`                   |
| `conf.backup.backup_user`          |            | ceph backup pool 用户名称                                    | `admin`                   |
| `conf.backup.backup_pool_name`     |            | ceph backup pool 名称                                      | `backups`                 |
| `conf.backup.size`                 |            | ceph backup pool 副本数                                     | `1`                       |


### Traffic Exposure Parameters

| Name                                | Form title | Description                                                                   | Value                    |
| ----------------------------------- | ---------- | ----------------------------------------------------------------------------- | ------------------------ |
| `service.cluster_domain_suffix`     |            | Kubernetes Service suffix                                                     | `cluster.local`          |
| `service.type`                      |            | Kubernetes Service type                                                       | `ClusterIP`              |
| `service.publicService.name`        |            | cinder public svc name                                                        | `cinder-api`             |
| `service.publicService.port`        |            | cinder public svc port                                                        | `8776`                   |
| `service.publicService.portname`    |            | cinder public svc port name                                                   | `ks-pub`                 |
| `service.internalService.name`      |            | cinder internal svc name                                                      | `cinder`                 |
| `service.internalService.httpPort`  |            | cinder internal svc http port                                                 | `80`                     |
| `service.internalService.httpName`  |            | cinder internal svc http port name                                            | `http`                   |
| `service.internalService.httpsPort` |            | cinder internal svc https port                                                | `443`                    |
| `service.internalService.httpsName` |            | cinder internal svc https port name                                           | `https`                  |
| `service.nodePorts.http`            |            | Node port for HTTP                                                            | `""`                     |
| `service.nodePorts.https`           |            | Node port for HTTPS                                                           | `""`                     |
| `service.clusterIP`                 |            | Cluster internal IP of the service                                            | `""`                     |
| `service.loadBalancerIP`            |            | cinder service Load Balancer IP                                               | `""`                     |
| `service.externalTrafficPolicy`     |            | cinder service external traffic policy                                        | `Cluster`                |
| `ingress.enabled`                   |            | Enable ingress record generation for cinder                                   | `true`                   |
| `ingress.pathType`                  |            | Ingress path type                                                             | `ImplementationSpecific` |
| `ingress.apiVersion`                |            | Force Ingress API version (automatically detected if not set)                 | `""`                     |
| `ingress.ingressClassName`          |            | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+) | `nginx`                  |
| `ingress.hostname`                  |            | Default host for the ingress record                                           | `cinder`                 |
| `ingress.path`                      |            | Default path for the ingress record                                           | `/`                      |


### Keystone Details

| Name                                    | Form title           | Description                       | Value                 |
| --------------------------------------- | -------------------- | --------------------------------- | --------------------- |
| `keystone.enabled`                      | 部署 keystone          | 是否部署keystone                      | `true`                |
| `openstack-dep.enabled`                 | 部署 openstack 依赖环境    | 是否部署 openstack 依赖环境               | `true`                |
| `openstack-dep.passwordSecretName`      | Secret Name          | openstack 环境密码的 secret 名称         | `openstack-password`  |
| `openstack-dep.connInfoSecret`          | ConnInfo secret name | openstack 依赖环境中生成服务URL得 secret 名称 | `openstack-conn-info` |
