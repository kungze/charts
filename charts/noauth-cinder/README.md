# noauth-cinder

noauth-cinder charts 是为了在 k8s 集群上部署 noauth 的 cinder-api 服务，是为了满足 cinder-csi-plugin 测试任务使用的。

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Moodle&trade; parameters

| Name                          | Description                                                    | Value                             |
| ----------------------------- | -------------------------------------------------------------- | --------------------------------- |
| `image.registry`              | Moodle image registry                                          | `docker.io`                       |
| `image.repository`            | Moodle image repository                                        | `douyali/cinder-api`              |
| `image.tag`                   | Moodle image tag (immutable tags are recommended)              | `latest`                          |
| `image.pullPolicy`            | Moodle image pull policy                                       | `IfNotPresent`                    |
| `image.pullSecrets`           | Specify docker-registry secret names as an array               | `[]`                              |
| `image.debug`                 | Specify if debug logs should be enabled                        | `false`                           |
| `entrypointImage.registry`    | Moodle image registry                                          | `quay.io`                         |
| `entrypointImage.repository`  | Moodle image repository                                        | `airshipit/kubernetes-entrypoint` |
| `entrypointImage.tag`         | Moodle image tag (immutable tags are recommended)              | `v1.0.0`                          |
| `entrypointImage.pullPolicy`  | Moodle image pull policy                                       | `IfNotPresent`                    |
| `entrypointImage.pullSecrets` | Specify docker-registry secret names as an array               | `[]`                              |
| `entrypointImage.debug`       | Specify if debug logs should be enabled                        | `false`                           |
| `replicaCount`                | Number of Moodle replicas (requires ReadWriteMany PVC support) | `1`                               |
| `containerPorts.http`         | Cinder HTTP container port                                     | `8776`                            |


### Traffic Exposure Parameters

| Name                               | Description                                      | Value       |
| ---------------------------------- | ------------------------------------------------ | ----------- |
| `service.type`                     | Cinder service type                              | `ClusterIP` |
| `service.port`                     | Cinder service HTTP port                         | `8776`      |
| `service.httpsPort`                | Cinder service HTTPS port                        | `443`       |
| `service.httpsTargetPort`          | Target port for HTTPS                            | `https`     |
| `service.nodePorts.http`           | Node port for HTTP                               | `""`        |
| `service.clusterIP`                | Cinder service Cluster IP                        | `""`        |
| `service.loadBalancerIP`           | Cinder service Load Balancer IP                  | `""`        |
| `service.loadBalancerSourceRanges` | Cinder service Load Balancer sources             | `[]`        |
| `service.externalTrafficPolicy`    | Cinder service external traffic policy           | `Cluster`   |
| `service.annotations`              | Additional custom annotations for Cinder service | `{}`        |
| `service.extraPorts`               | Extra port to expose on Cinder service           | `[]`        |


### Noauth Cinder API Config File Parameters

| Name                        | Description                  | Value    |
| --------------------------- | ---------------------------- | -------- |
| `conf.cinder.auth_strategy` | Auth strategy for cinder api | `noauth` |
| `conf.cinder.auth_type`     | Auth type for cinder api     | `none`   |


### Noauth Cinder API Autoscaling configuration

| Name                       | Description                                     | Value   |
| -------------------------- | ----------------------------------------------- | ------- |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for WordPress | `false` |
| `autoscaling.minReplicas`  | Minimum number of WordPress replicas            | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of WordPress replicas            | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage               | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage            | `50`    |


### Database parameters

| Name                                        | Description                                                                              | Value               |
| ------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements     | `true`              |
| `mariadb.architecture`                      | MariaDB architecture. Allowed values: `standalone` or `replication`                      | `standalone`        |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                     | `""`                |
| `mariadb.auth.database`                     | Database name to create                                                                  | `cinder`            |
| `mariadb.auth.username`                     | Database user to create                                                                  | `cinder`            |
| `mariadb.auth.password`                     | Password for the database                                                                | `123456`            |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                    | `true`              |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                          | `""`                |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                  | `["ReadWriteOnce"]` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                          | `8Gi`               |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production) | `""`                |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                 | `""`                |
| `externalDatabase.host`                     | External Database server host                                                            | `localhost`         |
| `externalDatabase.port`                     | External Database server port                                                            | `3306`              |
| `externalDatabase.user`                     | External Database username                                                               | `cinder`            |
| `externalDatabase.password`                 | External Database user password                                                          | `""`                |
| `externalDatabase.database`                 | External Database database name                                                          | `cinder`            |
| `externalDatabase.existingSecret`           | The name of an existing secret with database credentials                                 | `""`                |