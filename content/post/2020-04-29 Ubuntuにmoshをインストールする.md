---
title: "Ubuntuにmoshをインストールする"
date: 2020-04-29T18:00:00+09:00
tags: [mosh]
toc: yes
slug: install-mosh-on-ubuntu
---

Ubuntuにmoshをインストールして外部から`mosh`で接続できるようにします。

<!--more-->

## Environment

- サーバー: Ubuntu 20.04 LTS
- クライアント: macOS Catalina 10.15.4 (19E287)

## Setup Server

### Install

```bash
> sudo apt install mosh
```

### Firewall

mosh用のプリセットを使ってポートを開放します。

```bash
> sudo ufw allow mosh
```

ufwの設定を確認します。

```bash
> sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
60000:61000/udp (mosh)     ALLOW IN    Anywhere
60000:61000/udp (mosh (v6)) ALLOW IN    Anywhere (v6)
...
```

60000-61000までの1001個のUDPポートが開放されました。

## Connect from Client

### Install moch-client

macOSでHomebrewが使える環境では、次のコマンドだけでインストールできます。

```shell
> brew install mosh
```

WindowsでChocolateyが使える環境では、次のコマンドでインストールできるはずです (未検証)。[^choco]

```shell
> choco install mosh-for-chrome
```

### Connect

接続は簡単で、`ssh`の代わりに`mosh`コマンドを使うだけです。

```shell
> mosh mosh-server.example.com
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-26-generic x86_64)
[...]
```

[^choco]: https://chocolatey.org/packages/mosh-for-chrome

