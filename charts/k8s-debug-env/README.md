# k8s-debug-env

该 chart 是为了快速的在 k8s 环境中准备一个开发调试环境，该 chart 使用的容器镜像是 [kungze/ubuntu-develop-env](https://github.com/kungze/ubuntu-develop-env) 。

特点：
* 支持在容器内操作宿主机的容器（前提：部署 k8s 集群使用的 csi 必须是 docker）
* 容器内 /home 命令映射到了宿主机上的一个目录，无论 pod 怎么变化，/home 下的数据可以保持不变
* 可通过 ssh 登录 pod，pod 的 ssh 端口默认映射到 node 的 30022 端口，默认用户是 ubuntu，默认密码是 ChangeMe
* 可自动生成 kubeconfig 文件，容器内提前安装了 kubectl 命令
* 借助 [kubeapp](https://github.com/kubeapps/kubeapps) 可以实现图形化部署


## 快速部署

    helm repo add kungze https://kungze.github.io/charts
    helm install dev-debug-env kungze k8s-debug-env

在部署完成后推荐使用 vscode 的 [remote ssh](https://code.visualstudio.com/docs/remote/ssh) 远程连接到容器进行代码的开发调试。您也可以通过一个 shell 工具如 xshell 登录容器，对 k8s 集群网络，存储等进行测试。


## Parameters

### 镜像仓库

| Name            | Description                        | Value       |
| --------------- | ---------------------------------- | ----------- |
| `imageRegistry` | 镜像仓库，国内的可以换成 registry.aliyuncs.com | `docker.io` |


### 宿主机相关参数

| Name                        | Description                                                                                           | Value          |
| --------------------------- | ----------------------------------------------------------------------------------------------------- | -------------- |
| `hostConf.nodePort`         | pod 映射到宿主机上的端口，可通过 ssh 访问这个端口进入 pod 容器                                                                | `30022`        |
| `hostConf.dockerSocketPath` | 如果 cri 使用的是 docker，并且想在 pod 内部执行 docker 命令控制宿主机上的容器，需要传入宿主机上的 docker sockt 的路径，如：/var/run/docker.sock | `""`           |
| `hostConf.homeDirPath`      | 该目录（在宿主机上）会映射为 pod 容器内的 /home 目录，pod 内唯有 /home 目录下的数据会被持久保存，后面计划使用 pv 替换 hostdir                      | `/data/ubuntu` |


### 容器内用户和用户组

| Name                         | Description                                | Value      |
| ---------------------------- | ------------------------------------------ | ---------- |
| `containerConf.userName`     | ssh 用户名，在 pod 启动时会自动创建                     | `ubuntu`   |
| `containerConf.userGroup`    | 用户组，pod  启动时会自动创建                          | `ubuntu`   |
| `containerConf.userPassword` | 用户密码，可以在 pod 启动后 ssh 登录修改，但是 pod 重建后会恢复该密码 | `ChangeMe` |


### 配置 kubeconfig

| Name                           | Description                                                               | Value |
| ------------------------------ | ------------------------------------------------------------------------- | ----- |
| `kubeConfig.clusterName`       | 对应 ~/.kube/config 中的 cluster.name                                         | `""`  |
| `kubeConfig.clusterApiServer`  | 对应 ~/.kube/config 中的 cluster.server                                       | `""`  |
| `kubeConfig.clusterCaData`     | 对应 ~/.kube/config 中的 cluster.certificate-authority-data，需要经过 base64 加密    | `""`  |
| `kubeConfig.userName`          | 对应 ~/.kube/config 中的 users[0].name                                        | `""`  |
| `kubeConfig.userPassword`      | 对应 ~/.kube/config 中的 users[0].user.password                               | `""`  |
| `kubeConfig.userClientCaData`  | 对应 ~/.kube/config 中的 users[0].user.client-certificate-data，需要经过 base64 加密 | `""`  |
| `kubeConfig.userClientKeyData` | 对应 ~/.kube/config 中的 users[0].user.client-key-data，需要经过 base64 加密         | `""`  |