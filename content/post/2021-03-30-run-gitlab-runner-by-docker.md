---
title: Dockerを使用したGitLab Runnerのインストール方法
date: 2021-03-30T19:50:00+09:00
tags: [gitlab, docker]
toc: yes
---

GitLabにGitLab Runnerをインストールすると、リポジトリでジョブを実行したり、テストやデプロイの自動化などの機能が使えるようになります。この記事では、Dockerを使用してGitLab Runnerを実行・登録する方法について説明します。

<!--more-->

## Overview

次の3ステップで登録します。
- GitLab のトークンをチェックする
- GitLab Runnerを追加したいノードでregistrationを実行
- GitLab Runnerを追加したいノードでGitLab Runnerコンテナを実行

## Prerequisites

- GitLab Runnerをインストールするノードで`docker`コマンドが利用できる必要があります。
- ノードにGitLab v13.6.2がインストール済みで、git.your.domainで公開されているものとします。

## Register node

詳細な手順は以下のとおりです。

- 管理者エリア - GitLab（[https://git.your.domain/admin/runners](https://git.your.domain/admin/runners)）を開きます（GitLabのAdmin権限が必要です）。
- 表示されている「登録トークン」をメモします。
- Runnerをインストールするノードにsshします。
- RunnerをGitLabにregistrationするために、次のコマンドを実行します。

```shell
docker run --rm -it -v /etc/gitlab-runner:/etc/gitlab-runner gitlab/gitlab-runner:latest register \
    --non-interactive \
    --url "https://git.your.domain" \
    --registration-token "<registration-token>" \
    --name $(hostname -s) \
    --run-untagged \
    --tag-list 'cluster/<cluster-name>,os/<os-name>/<os-version>' \
    --executor "docker" \
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
    --docker-volumes /builds:/builds \
    --docker-image gcr.io/buildpacks/builder \
    --docker-privileged
```

- `<registration-token>` には、上でメモしたトークンを書きます。
- `<node-name>` には、ノード名を書きます。例: pi-0
- `<cluster-name>` には、クラスター名を書きます。例: pi
- `<os-name>` には、OS名を書きます。例: ubuntu、centos
- `<os-version>` には、OSのバージョンを書きます。例: 20.04
- これらの値は 管理者エリア - GitLab（[https://git.your.domain/admin/runners](https://git.your.domain/admin/runners)）に表示されるので分かりやすいように付けてください。
- `--docker-image gcr.io/buildpacks/builder`は、設定がない場合のデフォルトのビルドイメージを指定しています。これはGoogle Cloud Runで使用されているビルドバックで、標準のアプリの自動ビルドを可能にします。
- `--docker-privileged`により、コンテナがprivilegedモードで実行可能になります。これは、systemdの実行が必要なコンテナなど、Docker in Dockerを実行するために必要です。特権コンテナが不要・使えない場合は省略できます。
- registrationが成功すると、次のような設定ファイルが`/etc/gitlab-runner/config.toml`に生成されます。確認してください。

```toml
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

  [[runners]]
  name = "pi-0"
  url = "https://git.your.domain"
  token = "<registration-token>"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.docker]
    tls_verify = false
    image = "gcr.io/buildpacks/builder"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/builds:/builds", "/cache"]
    shm_size = 0
```

## Run the container

- 実際に処理を行うRunnerコンテナを実行します。以下のコマンドを実行してください。

```shell
docker run -d --name gitlab-runner --restart always \
       -v /etc/gitlab-runner/:/etc/gitlab-runner/ \
       -v /var/run/docker.sock:/var/run/docker.sock \
       gitlab/gitlab-runner
```

- `"--restart always"`オプションを指定することで、再起動時にコンテナが自動起動するようになります。
- https://git.your.domain/admin/runners にノードが表示されればインストール完了です。ランナー実行時にジョブが割り当てられるようになったはずです。

## References

- [Install GitLab Runner | GitLab](https://docs.gitlab.com/runner/install/)
