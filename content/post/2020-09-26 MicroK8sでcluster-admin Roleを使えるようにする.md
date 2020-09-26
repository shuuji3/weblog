---
title: MicroK8sでcluster-admin Roleを使えるようにする
date: 2020-09-26T10:00:00+09:00
tags: [kubernetes, microk8s, clusterrole]
toc: yes
slug: enable-cluster-admin-role-on-microk8s
---

この記事では、MicroK8s上で`cluster-admin`のClusterRoleを利用できるようにする方法を説明します。

<!--more-->

## TL;DR

```shell
sudo mirok8s enable rbac
```

## RBAC is not enabled by default on MicroK8s

[MicroK8s](https://microk8s.io/)では、デフォルトでは[RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)が有効ではありません。

```shell
sudo microk8s status
```

```shell
microk8s is running
high-availability: yes
  datastore master nodes: xxx.yyy.zzz.www
  datastore standby nodes: xxx.yyy.zzz.www
addons:
  enabled:
(...)
  disabled:
(...)
    rbac                 # Role-Based Access Control for authorisation
```

そのため、`cluster-admin`のClusterRoleを使用するには、初めにRBACを使えるようにする必要があります。

### At the past, we need to install RBAC manually

なお、以前は、以下のIssueに書かれているように、手動でリソースを作成する必要があったようです。

[RBAC: cluster-admin not installed by default · Issue #84 · ubuntu/microk8s](https://github.com/ubuntu/microk8s/issues/84)

最近のバージョンのKubernetesではRBACを使うのが当たり前になっているようだったので、MicroK8sでもデフォルトで使えるのかと思っていましたが、違いました。

### In case of kind

たとえば、kindでは、デフォルトで有効になっているので、初めから`cluster-admin`が存在します。

```shell
k get clusterrole | grep admin
```

```shell
(...)
admin                                                                  2020-09-19T12:53:24Z
cluster-admin                                                          2020-09-19T12:53:23Z
(...)
```

## Enable RBAC add-on

現在では、RBACは、アドオンの有効化だけで利用できるようになっています。

```shell
sudo microk8s enable rbac
```

`enable`サブコマンドで`rbac`プラグインを有効にします。

```shell
Enabling RBAC
Reconfiguring apiserver
Adding argument --authorization-mode to nodes.
Configuring node xxx.yyy.zzz.www
Configuring node xxx.yyy.zzz.www
Configuring node xxx.yyy.zzz.www
RBAC is enabled
```

クラスタに加入しているワーカーノードも同時に設定されます。

## Confirm `cluster-admin` has been enabled

```shell
k get clusterrole
```

ClusterRoleを確認すると、さまざまなコンポーネント向けのClusterRoleが大量に追加されていて、その中に`cluster-admin`ロールも追加されていることが分かります。

```shell
(...)
cluster-admin                                                          2020-09-26T00:46:39Z
admin                                                                  2020-09-26T00:46:51Z
(...)
```
