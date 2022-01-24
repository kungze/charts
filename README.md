# Kungze charts

这个仓库维护的是 kungze 团队使用到的一些 helm charts，通过这些 charts 能更方便的在 k8s 上搭建 openstack，安装 kungze 维护开发的项目。openstack 相关的 charts 主要来自于 [openstack-helm](https://opendev.org/openstack/openstack-helm)，由于原社区需要考虑兼容很多东西，而且使用的 chart api 版本还是 v1，直接把我们的改动提交到原社区比较麻烦。因此我们从 openstack-helm 中提取一些我们需要的 charts 放在这个仓库维护。

**目前该仓库还在持续开发中，在使用时可能会遇到各种问题，欢迎通过 [github issue](https://github.com/kungze/charts/issues) 向我们反馈，等到基本可用时，会去掉本行说明。**

## 使用方法

在使用之前 [Helm](https://helm.sh) 的安装是必须的，安装方法请参考[官方文档](https://helm.sh/zh/docs/)。helm 安装好之后，执行下面命令添加我们的仓库：

    helm repo add kungze https://kungze.github.io/charts

然后执行 `helm repo update` 把仓库信息通过到本地。可以通过 `helm search repo kungze` 查询这个仓库包含的所有 charts。

安装命令：

    helm install my-<chart name> kungze/<chart name>

卸载命令：

    helm delete my-<chart name>
