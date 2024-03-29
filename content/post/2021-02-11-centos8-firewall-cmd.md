---
title: "CentOS 8でのファイアウォールの標準的な設定方法"
date: 2021-02-12T13:40:00+09:00
tags: [centos, firewall]
toc: yes
aliases:
  - centos8-firewall-cmd
---

CentOS 8では、iptablesではなく、firewalldを操作する`firewall-cmd`を利用してファイアウォールを設定するのが一般的です。この記事では、最も基本的な操作である、特定のサービスのポートを公開する方法について説明します。

<!--more-->

## プロトコルとポート番号を利用する方法

以下のfirewalldの公式ドキュメントには、HTTPプロトコルで利用されるTCP 80番ポートを公開する設定方法が説明されています。

[Documentation - HowTo - Open a Port or Service | firewalld](https://firewalld.org/documentation/howto/open-a-port-or-service.html)

次のコマンドを実行すると、publicゾーンに追加されたインターフェイスを経由するTCP 80番ポートへの通信が許可されます。

```shell
firewall-cmd --zone=public --add-port=80/tcp
```

firewall-cmdコマンドは、デフォルトでは設定はメモリ上に一時的に保持されるだけです。そのため、デーモンを再起動すると設定は失われます。デーモンの再起動やノードの再起動後にも保持されるように設定を永続化するには、`--permanent`オプションを指定します。

```shell
firewall-cmd --permanent --zone=public --add-port=80/tcp
```

これで設定が永続化されました。

## プリセットを利用する方法

よく知られたサービスに対しては、デフォルトで利用されるwell-knownなポートのプリセットが/etc/servicesというテキストファイルに定義されています。このプリセットは、firewall-cmdでも利用することができます。サービス名で指定することで、ポート番号を暗記せずに済み、設定のリーダビリティも向上します。

たとえば、httpではtcp/80ポートを使用することが知られているため、前のセクションと同等のポートの永続的な開放は、プリセットhttpを利用することで、次のコマンドでも実行できます。

```shell
firewall-cmd --permanent --zone=public --add-service=http
```

> /etc/servicesに書かれたポート番号は、ファイルの冒頭に書かれているように、[IANA（Internet Assigned Numbers Authority）](https://en.wikipedia.org/wiki/Internet_Assigned_Numbers_Authority)が管理しているRFC1700（ref. [List of TCP and UDP port numbers - Wikipedia](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers)）を元に作成されています。IANAは、インターネットのDNSやIPアドレスも管理している組織です。

## 別の例: NFSサーバー用のポートを開放する

別の例として、たとえば、ローカルネットワーク上でNFSサーバーが稼働している環境で、ノード間でデータ転送ができるようにポートを開放することを考えます。HTTPのポートが80番であることは多くの人が知っていますが、サーバーのポート番号を記憶している人は稀でしょう。

well-knownなポート番号を確認するには、`grep`コマンドで`/etc/services`を検索します。実際に探してみると、次の3つのエントリが見つかりました。

```shell
> egrep '^nfs ' /etc/services
nfs             2049/tcp        nfsd shilp      # Network File System
nfs             2049/udp        nfsd shilp      # Network File System
nfs             2049/sctp       nfsd shilp      # Network File System
```

これらの結果から、NFSサーバー上のファイルを利用するためには、nfsdが利用する2049番ポートを開放すればよいことがわかります。

ポート番号ベースでfirewall-cmdを使って設定しようとすると、このようにポート番号を確認した後、この場合にはプロトコルごとに3つのコマンドを実行する必要があります。しかし、プリセットを利用すれば、次のように1行のコマンドを実行するだけで完結します。

```shell
firewall-cmd --permanent --zone=internal --add-service=nfs
```

こちらの方が、よりシンプルで美しいと思えます。

## Ubuntuの場合: ufw

Ubuntuでは[ufw](https://ubuntu.com/server/docs/security-firewall)（Uncomplicated Firewall）で設定します。
