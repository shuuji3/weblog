---
title: lxcで作ったLinuxコンテナでデフォルトでssh接続できるようにする
date: 2020-09-18T08:00:00+09:00
tags: [lxc, cloud-init, ssh]
toc: true
---

lxcでLinuxコンテナをつくったとき、デフォルトでは直接ssh接続することができません。GitHubのキーをインポートするcloud-initを利用することで、普段使用している公開鍵を使ってsshできるように設定することができます。

<!--more-->

## Motivation

xcでLinuxコンテナをつくったとき、デフォルトでは直接ssh接続することができず、シェルにログインするためには、以下のようにして`lxc exec`コマンドを使用して、シェルを指定して実行する必要があります。これは、Dockerコンテナでシェルを実行するのと似ています。

```shell
shuuji3@precision-1 ~/
> lxc exec ubuntu-2004 bash

root@ubuntu-2004:~# hostnamectl
   Static hostname: ubuntu-2004
         Icon name: computer-container
           Chassis: container
        Machine ID: f81100fd83eb42a586ae2593b5b8edfb
           Boot ID: 87cc4010a5c4496cb61145282b457642
    Virtualization: lxc
  Operating System: Ubuntu 20.04.1 LTS
            Kernel: Linux 5.4.0-47-generic
      Architecture: x86-64
```

たとえば、AnsibleをテストするためにLXCコンテナの環境を利用したいときなどには、ssh接続できることが望ましいですが、デフォルトでは公開鍵が登録されていないため、そのままではssh接続して利用することができません。

## Resolution using cloud-init

LXCは、コンテナの作成時にcloud-init[cloud-init]の設定ファイルを読み込み、コンテナが作成されたタイミングで設定を自動的に適用することができます。これを利用して、ユーザーの作成やssh公開鍵の登録ができます。

今回は、自分のローカルのユーザーアカウント`shuuji3`に対して、<https://github.com/shuuji3>のGitHubのアカウントの公開鍵を登録して、パスワードレスで`sudo`を使えるようにします。そのためには、以下のような内容で`cloud-init.yaml`を作ります。

```yaml
#cloud-config
users:
  - name: shuuji3
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-import-id: gh:shuuji3
    shell: /bin/bash
```

なお、ここで使われている`ssh-import-id`というキーは、同名のアプリケーション[ssh-import-id](https://launchpad.net/ssh-import-id)で処理されています。`gh:`というprefixを付けるとGitHubのアカウントから公開鍵がimportされます。その他には、Launchpadの公開鍵(`lp:`prefixを指定)が対応しています。現在、GitLabに対応するためのpatchを送ることを検討しています。

## Create lxc container with cloud-init

作成した`cloud-init.yaml`を使用してコンテナを起動するには、次のように標準入力で設定ファイルを与えます。

```shell
lxc launch images:ubuntu/20.04 ubuntu-2004 < cloud-init.yaml
```

これにより、`images:ubuntu/20.04`というUbuntuの恭順のLXCコンテナイメージをもとに、`ubuntu-2004`という名前で、`cloud-init.yaml`を実行するコンテナが作成されます。

このようなCLIでは、`--config`や`-c`パラメータでファイルをしていするのが普通のような気がするので、少し不思議な印象です。歴史的な経緯がありそうで少し気になります。

## How to connect to the container via ssh

コンテナにSSH接続するには、まずコンテナのIPアドレスを確認します。

```shell
> lxc ls
+-------------+---------+----------------------+----------------------------------------------+-----------+-----------+
|    NAME     |  STATE  |         IPV4         |                     IPV6                     |   TYPE    | SNAPSHOTS |
+-------------+---------+----------------------+----------------------------------------------+-----------+-----------+
| centos8     | RUNNING | 10.164.85.58 (eth0)  | fd42:95d4:dbf:1367:216:3eff:fe10:1954 (eth0) | CONTAINER | 0         |
+-------------+---------+----------------------+----------------------------------------------+-----------+-----------+
| ubuntu-2004 | RUNNING | 10.164.85.246 (eth0) | fd42:95d4:dbf:1367:216:3eff:fe4e:5ee4 (eth0) | CONTAINER | 0         |
+-------------+---------+----------------------+----------------------------------------------+-----------+-----------+
```

`ubuntu-2004`のIPv4アドレスは`10.164.85.246`なので、`ubuntu`ユーザーで`ssh`します。

```shell
> ssh ubuntu@10.164.85.246
```

## References

- [cloud-init]: [cloud-init: The standard for customising cloud instances](https://cloud-init.io/)