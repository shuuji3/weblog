---
title: lstopoをソースからコンパイルする
date: 2020-07-22T23:30:00+09:00
tags: [lstopo, make]
toc: yes
aliases:
  - compile-lstopo-source-code
---

lstopoのソースコードをダウンロードしてコンパイルします。

<!--more-->

## Motivation

スーパーコンピュータの[Cygnus](https://www.ccs.tsukuba.ac.jp/eng/supercomputers/#Cygnus)上で、`lstopo`コマンドを使いたくなりましたが、インストールされていませんでした。sudo権限を持っていないので、ソースからコンパイルする必要がありました。

## Shell script

`lstopo`のソースコードをダウンロード、コンパイル、実行するだけのシェルスクリプトです。

{{< gist shuuji3 a6fc45a4059e83fc446fe78e581185d3 >}}
