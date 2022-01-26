# Cinder CSI volume provisioner

在 K8s 环境中部署 [cinder-csi-plugin](https://github.com/kungze/cinder-csi-plugin) 插件，该插件 Driver 支持两种认证策略：

- keystone openstack 环境需对接 keystone 认证
- noauth openstack 环境只需部署 cinder 相关组件（cinder-api、cinder-volume、cinder-scheduler）

cinder-csi-plugin 插件存储后端目前只支持 ceph rbd

## 快速部署

```
helm repo add kungze https://kungze.github.io/charts
helm install cinder-csi-plugin kungze cinder-csi-plugin
```

## Parameters

### Global parameters

| Name                      | Description                               | Value |
| ------------------------- | ----------------------------------------- | ----- |
| `global.nameOverride`     | Override chart Name                       | `""`  |
| `global.fullnameOverride` | Override release Name                     | `""`  |
| `global.timeout`          | The csi related container startup timeout | `3m`  |


### Cloud configuration

| Name                     | Description                            | Value                                            |
| ------------------------ | -------------------------------------- | ------------------------------------------------ |
| `cloud.authStrategy`     | The strategy to use for authentication | `noauth`                                         |
| `cloud.username`         | Keystone authentication username       | `admin`                                          |
| `cloud.password`         | Keystone authentication password       | `password`                                       |
| `cloud.tenantName`       | Keystone authentication tenantName     | `admin`                                          |
| `cloud.authUrl`          | Keystone authentication authUrl        | `http://keystone.openstack.svc.cluster.local/v3` |
| `cloud.cinderListerAddr` | Cinder api listen addr                 | `""`                                             |


### Ceph Related Configuration

| Name                   | Description                               | Value                              |
| ---------------------- | ----------------------------------------- | ---------------------------------- |
| `ceph.enabledCephAuth` | Whether to enable cepH authentication     | `true`                             |
| `ceph.keyringName`     | The user keyring name using the Ceph pool | `cinder-volume-rbd-keyring`        |
| `ceph.keyring`         | The user keyring using the Ceph pool      | `W2NsaWVudC5jaW5kZXJd`             |
| `ceph.configMapName`   | The ceph config file configmap name       | `ceph-etc`                         |
| `ceph.data.cephConfig` | The ceph config file data                 | `[global]`                         |


### Storageclass Configuration

| Name                                       | Description                                     | Value   |
| ------------------------------------------ | ----------------------------------------------- | ------- |
| `storageClass.enabled`                     | Whether to create storageClass                  | `true`  |
| `storageClass.delete.isDefault`            | Set up the storageClass reclaimpolicy to delete | `false` |
| `storageClass.delete.allowVolumeExpansion` | Set up the storageClass allowVolumeExpansion    | `true`  |
| `storageClass.retain.isDefault`            | Set up the storageClass reclaimpolicy to retain | `false` |
| `storageClass.retain.allowVolumeExpansion` | Set up the storageClass allowVolumeExpansion    | `true`  |


### Noauth Cinder Configuration

| Name                                                     | Description                        | Value  |
| -------------------------------------------------------- | ---------------------------------- | ------ |
| `noauth-cinder.replicaCount`                             | cinder api pod replicaCount number | `1`    |
| `noauth-cinder.mariadb.enabled`                          | Whether to enable mariadb          | `true` |
| `noauth-cinder.mariadb.primary.persistence.enabled`      | Mariadb Whether to use PVC         | `true` |
| `noauth-cinder.mariadb.primary.persistence.storageClass` | storageclass name                  | `""`   |
