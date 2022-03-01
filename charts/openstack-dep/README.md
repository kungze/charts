# openstack-dep

openstack-dep 用于安装openstack依赖环境，其中包括：mariadb、rabbitmq、memcached、nginx-ingress-controller、gen-password。  
安装成功后会生成一个包含 mariadb、rabbitmq、memcached 连接信息的 secrets。

## Parameters

### Global parameters

| Name                      | Form title | Description                                             | Value                 |
| ------------------------- | ---------- | ------------------------------------------------------- | --------------------- |
| `global.imageRegistry`    |            | Global Docker image registry                            | `""`                  |
| `global.imagePullSecrets` |            | Global Docker registry secret names as an array         | `[]`                  |
| `global.storageClass`     |            | Global StorageClass for Persistent Volume(s)            | `""`                  |
| `connInfoSecret`          |            | openstack dependency env generate conn info secret name | `openstack-conn-info` |
| `clusterDomainSuffix`     |            | openstack dependency env generate conn info secret name | `cluster.local`       |
| `gen-password.secretName` | 自动生成密钥名称   | 自动生成openstack密钥名称                                       | `openstack-password`  |


### Database Parameters

| Name                                       | Form title      | Description                                                               | Value                |
| ------------------------------------------ | --------------- | ------------------------------------------------------------------------- | -------------------- |
| `mariadb.enabled`                          | 开启mariadb       | Deploy a MariaDB server to satisfy the applications database requirements | `true`               |
| `mariadb.architecture`                     | MariaDB架构       | MariaDB architecture. Allowed values: `standalone` or `replication`       | `standalone`         |
| `mariadb.auth.existingSecret`              | MariaDB auth 配置 | Use existing secret for password details                                  | `openstack-password` |
| `mariadb.primary.persistence.enabled`      |                 | Enable persistence on MariaDB using PVC(s)                                | `true`               |
| `mariadb.primary.persistence.storageClass` |                 | Persistent Volume storage class                                           | `""`                 |
| `mariadb.primary.persistence.accessModes`  |                 | Persistent Volume access modes                                            | `[]`                 |
| `mariadb.primary.persistence.size`         |                 | Persistent Volume size                                                    | `8Gi`                |


### RabbitMQ chart parameters

| Name                                | Form title  | Description                                 | Value       |
| ----------------------------------- | ----------- | ------------------------------------------- | ----------- |
| `rabbitmq.enabled`                  | 开启rabbitmq  | Enable/disable RabbitMQ chart installation  | `true`      |
| `rabbitmq.auth.username`            | RabbitMQ用户名 | RabbitMQ username                           | `openstack` |
| `rabbitmq.auth.password`            | RabbitMQ密码  | RabbitMQ password                           | `openstack` |
| `rabbitmq.persistence.enabled`      |             | Enable persistence on Rabbitmq using PVC(s) | `true`      |
| `rabbitmq.persistence.storageClass` |             | Persistent Volume storage class             | `""`        |
| `rabbitmq.persistence.accessModes`  |             | Persistent Volume access modes              | `[]`        |
| `rabbitmq.persistence.size`         |             | Persistent Volume size                      | `8Gi`       |


### Memcached chart parameters

| Name                     | Form title  | Description                                            | Value   |
| ------------------------ | ----------- | ------------------------------------------------------ | ------- |
| `memcached.enabled`      | 开启memcached | Deploy a Memcached server for caching database queries | `true`  |
| `memcached.service.port` |             | Memcached service port                                 | `11211` |


### nginx-ingress-controller chart parameters

| Name                                             | Form title                 | Description                                                                      | Value         |
| ------------------------------------------------ | -------------------------- | -------------------------------------------------------------------------------- | ------------- |
| `nginx-ingress-controller.enabled`               | 开启nginx-ingress-controller | Deploy a ingress controller server                                               | `true`        |
| `nginx-ingress-controller.service.type`          |                            | controller service type                                                          | `ClusterIP`   |
| `nginx-ingress-controller.podLabels.app`         |                            | for nginx-ingress-controller pod add labels to be compatible with SVC            | `ingress-api` |
| `nginx-ingress-controller.kind`                  |                            | Install as DaemonSet                                                             | `DaemonSet`   |
| `nginx-ingress-controller.daemonset.useHostPort` |                            | If `kind` is `DaemonSet`, this will enable `hostPort` for `TCP/80` and `TCP/443` | `true`        |
