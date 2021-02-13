---
title: Gitpod上でHugoのサイトの環境構築を自動化する
date: 2021-02-13T17:30:00+09:00
tags: [gitpod, hugo]
toc: yes
---

このブログは[Hugo](https://gohugo.io/)で構築されていますが、執筆は[Gitpod](https://www.gitpod.io/)上で行っています。この記事では、このブログのリポジトリで使用している`.gitpod.yml`ファイルについて説明します。`.gitpod.yml`を作成すると、Gitpodのワークスペースを開いたときの開発環境の構築を自動化できます。最終的に、Gitpodのワークスペースを開くだけで、Hugoでブログをビルドして、プレビューができる環境が用意されるようにします。

<!--more-->

## Dockerデーモンの起動が完了を待機するシェルスクリプトを作る

まずは、Dockerデーモンの起動が完了するのを待機するためのシェルスクリプトを作ります。これは、後に`tasks:`で必要になるものです。

Gitpod上では、`sudo docker-up`コマンドを実行すると、[rootlessモード](https://docs.docker.com/engine/security/rootless/)でDockerデーモン（`dockerd`）が起動されます（2021-02-13時点では、Experimentalな機能）。その結果、Dockerのソケットが`/var/run/docker.sock`に作成され、DockerのCLIはこのソケットを使用してdockerdと通信できるようになります。(rootlessモードについては、詳しくは、別の記事「[DockerのRootlessモードとGitpod](/post/2021-02-13-docker-rootless-mode-and-gitpod/)」を参照してください。)

したがって、Dockerのソケットとの疎通が確認できるコマンドを実行することで、dockerdが利用可能になったかどうかを判別できます。今回は、`docker info`の終了コードで判断することにします。`docker info`が失敗する場合と成功する場合で、終了コードはそれぞれ次のように`1`と`0`になります。

**失敗する場合**

```shell
gitpod /workspace/weblog $ docker info; echo exit: $?
Client:
 Debug Mode: false

Server:
ERROR: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
errors pretty printing info
exit: 1
```

**成功する場合**

```shell
gitpod /workspace/weblog $ docker info; echo exit: $?
Client:
 Debug Mode: false

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 1
 Server Version: 19.03.14

...
exit: 0
```

よって、終了コードが0になるまでpollingすることで、Dockerが利用できるまで待機することができます。

```shell
while [[ $(docker info > /dev/null; echo $?) != 0 ]]; do
   sleep 1
done
```

## 作成した`.gitpod.yml`ファイル

前のセクションの実験を踏まえて、以下のような`.gitpod.yml`ファイルを作成しました。

```yaml
# List the ports you want to expose and what to do when they are served. See https://www.gitpod.io/docs/config-ports/
ports:
  - port: 3000
    onOpen: open-browser

# List the start up tasks. You can start them in parallel in multiple terminals. See https://www.gitpod.io/docs/config-start-tasks/
tasks:
  - command: |
      while [[ $(docker info > /dev/null; echo $?) != 0 ]]; do
          sleep 1
      done
      make serve
  - command: sudo docker-up
```

### `posts:`の定義

`ports:`は、Gitpodに3000番ポートでサービスが公開されることを教えます。`onOpen: open-browser`というオプションを指定すると、サービスが公開されたタイミングで、新しいタブが開き、プレビューが表示されます。

### `tasks:`の定義

`tasks:`では、`command`キーを含むdictionaryの配列を定義しています。Gitpodのワークスペースが起動すると、初めにここで定義されたコマンドがシェルで実行されます。各dictionaryごとに独立したシェルが起動するため、ここでは2つのシェルが起動します。

1番目のシェルでは、前のセクションで作ったコードを使ってDockerが利用できるようになるまで待機し、その後、`make serve`を実行します。コマンドの実体は`Makefile`で定義されていて、以下のコマンドが実行されます。

```shell
docker run --rm --name "weblog-serve" -p 3000:1313 -v $(CURDIR):/src --volume /tmp/hugo-build-output:/output -w /src -e HUGO_WATCH=1 jojomi/hugo hugo serve --buildFuture --bind 0.0.0.0
```

HugoのDockerコンテナを使って、`hugo`コマンドでブログをビルドして、3000番ポートで公開するという内容です。

2番目のシェルでは、`sudo docker-up`コマンドを実行します。これは、ユーザースペースでRootlessモードのDockerデーモンを起動してDocker CLIから利用できるように環境構築してくれるヘルパーコマンドです。`dockerd`が利用できるようになると、1番目のシェルは`while`ループから抜け出して、`docker run`でHugoコンテナを実行できるようになります。

## まとめ: `.gitpod.yml`で可能になったこと

この`.gitpod.yml`を作成したことで、Gitpodでリポジトリのワークスペースを開くだけで、以下のことが自動で行われるようになりました。

- Rootressモードで`dockerd`が起動して、開発環境でDockerが利用できるようになる。
- Hugoコンテナでブログがビルドされ、記事を編集するとすぐに再ビルドされる執筆環境が準備される。
- ビルドされたブログのプレビューが別のタブで表示される。

## 残されている課題

`.gitpod.yml`とは関係ありませんが、現在、プレビューでテーマが正しく読み込まれていないため、CSSが正しく使われない問題があります。おそらくHugoを十分に理解していないときにこのリポジトリを作ったので、GitのSubmoduleやファイルの配置などに問題があるか、Dockerコンテナのマウント設定やHugoのオプションなどがどこか間違っているのではないかと思います。

また、リンクをクリックしてもホストのパスが違うため、手動でURLを書き換える必要があります。どちらも修正したいです。

## 参考文献

- [Exposing Ports - Gitpod](https://www.gitpod.io/docs/config-ports/) - `ports:`オプションに関するドキュメント
- [Start Tasks - Gitpod](https://www.gitpod.io/docs/config-start-tasks/) - `tasks:`オプションに関するドキュメント
