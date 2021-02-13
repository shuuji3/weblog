---
title: GitpodにおけるDockerのRootlessモードの活用
date: 2021-02-13T18:30:00+09:00
tags: [gitpod, docker, rootless]
toc: yes
---

この記事では、DockerのRootlessモードと、Gitpodでの活用について説明します。

<!--more-->

## DockerのRootlessモード

RootlessモードでDockerを使うと、ユーザー空間上でユーザー権限で`dockerd`が起動されます。これにより、通常のroot権限で実行される`dockerd`に比べて安全にDockerコンテナが実行できるようになります。

Dockerのrootlessモードは、主にAkihiro Sudaさんが実装しています。Dockerでは長い間experimentalな状態で、利用には別のバイナリのインストールが必要でした。しかし、v20.10でようやくGAとなり、標準のDockerで利用できるようになりました (ref. [New features in Docker 20.10 (Yes, it’s alive) | by Akihiro Suda | nttlabs | Medium](https://medium.com/nttlabs/docker-20-10-59cc4bd59d37))。

> 最近では、Kubernetesでもrootlessモードの実装が活発に進められています (ref. [keps/127: Support User Namespaces by mauriciovasquezbernal · Pull Request #2101 · kubernetes/enhancements](https://github.com/kubernetes/enhancements/pull/2101))。

## Gitpodでの活用

Gitpodでは長い間、開発環境のユーザー環境で`docker`コマンドを利用できませんでした。Gitpod自体が共有環境で動いているため、rootユーザーで動作している`dockerd`へのアクセスはセキュリティ上許可することが不可能でした。以下のPodcastで、Dockerを利用できるようにする試みを行っている話がされてます。

[Gitpod: Cloud Development Environments with Johannes Landgraf and Sven Efftinge - Software Engineering Daily](https://softwareengineeringdaily.com/2020/10/14/gitpod-cloud-development-environments-with-johannes-landgraf-and-sven-efftinge/)

その後、Gitpodでは、この問題を解決するためにRootlessモードを利用することになり、一般に利用できるようになったことが、[2020年のクリスマスに発表されました](https://www.gitpod.io/blog/root-docker-and-vscode/)。Gitpod上では、`sudo docker-up`コマンドを実行すると、[rootlessモード](https://docs.docker.com/engine/security/rootless/)でDockerデーモン（dockerd）が起動されます。なお、2021-02-13時点では、Feature Previewなので、利用するにはオプションから有効にする必要があります。

RootlessモードのDockerや、それを利用したGitpod内のしくみについては、次の動画で詳しく解説されています。

{{< youtube l4I2TVAnBuw >}}
