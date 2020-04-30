---
title: "Modernizing workloads with Migrate for Anthos - Google Cloud Platform ‐ YouTube"
date: 2020-04-29T17:00:00+09:00
tags: [watching, google-kubernetes-engine, anthos]
toc: true
---
<!--more-->

## Source

[Modernizing workloads with Migrate for Anthos - Google Cloud Platform ‐ YouTube](https://www.youtube.com/watch?v=7OgYaocQFwo&feature=em-uploademail&loop=0)

## Abstract

vmware上で動いているCentOS 4/5の古い仮想マシンをGKE上にマイグレーションする方法を説明している動画の視聴メモです。

## `migctl`と`kubectl`を使用したマイグレーションの実行

Anthosのマイグレーションの実行用に`migctl`というCLIがあるようです。

動画では、まず、`migctl`の様々なサブコマンドを使用して、vmwareの情報からリソースファイルを作成、Google Cloud Registoryにコンテナを登録、Google Cloud Storageにリソースファイルをアップロードしています。

その後、作成されたDeploymentのYAMLファイルに対して、Kubernetesの通常のコマンド`kubectl apply`を適用することで、vmwareの仮想マシンと同等のリソースがGKE上に作成され、マイグレーションが完了しました。

## Comments

大まかな流れは把握できましたが、実行された各コマンドの詳しい説明がなかったので、それぞれのコマンドの役割は概要しか分かりませんでした。

次のページでリファレンスが読めるので、実際に使うときにはここで詳細を確認できそうです。

migctl reference  |  Migrate for Anthos  |  Google Cloud - https://cloud.google.com/migrate/anthos/docs/migctl-reference

他の人も同じことを考えていたようで、"Well explained, but can be more detailed"のようなコメントもありました。🙂

