---
title: Kubernetesへの初めてのコントリビューション
date: 2020-05-03T15:15:00+09:00
tags: [kubernetes, hugo]
toc: yes
---

KubernetesのドキュメントにPull-Requestを送りました。

<!--more-->

## Pull-Request

[Fix a broken table in contribute/new-content/overview.md by modifying shortcodes by shuuji3 · Pull Request #20733 · kubernetes/website](https://github.com/kubernetes/website/pull/20733)

## What

Kubernetesのドキュメントの中にコントリビューター向けにコントリビューション方法を説明するドキュメントがあります。このドキュメントを読んでいると、テーブルのレイアウトが崩れているのを見つけたので、修正するPull-Requestを作りました。

## Problem

問題の原因は、Markdownの中で、次のようにcodeの中でHugoのshortcodesを展開する部分があり、そのshortcodesのもととなるHTMLファイルの末尾に改行文字が含まれていたためでした。それにより、

```markdown
`dev-release-1.18`
```

と展開されるべきなのに、閉じバッククオートの前に改行が挿入されてしまい、

```markdown
`dev-release-1.18
`
```

のようになり、codeが正しくレンダリングできなくなってしまっていました。

## Future Works

Kubernetesのドキュメントは日本語に翻訳されていないページがまだたくさん残っています。今CKAD/CKAのための勉強をしていて、ドキュメントを読む機会が多いので、興味のあるページの日本語翻訳をしてコントリビュートしていきたいと思っています。
