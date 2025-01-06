---
title: Translating psycopg3 documentation
date: 2025-01-06
tags:
- psycopg3
- translation
toc: true
---
                                   
> This post was actually written on March 25, 2023, but completely forgot to publish. During that period, I wrote [Takahē articles](post/2024-03-13-takahe-gihyo-article) and translated psycopg3 documentation into Japanese at the same time. 

I continue [translating psycopg3 into Japanese](https://psycopg3-ja.translation.shuuji3.xyz/) one by one. It's fun to learn unknown PostgreSQL features and how psycopg3 is handling connections and queries under the hood for database libraries in Python!

<!--more-->

## ReStructuredText syntax

By translating documentation written in ReStructuredText syntax, I become much familiar with this syntax and finally come to get confident with them. Surely I read in a lot of various Python documentations and translated huge amount of Django translation text on Transifex. But somehow I couldn't fully understand a few syntaxes.

That lack of confidence has almost disappeared and I can see the power and flexibility of this syntax now.

## Contributing to `sphinx-socialgraph`

I noticed that psycopg documentation doesn't have any OpenGraph Protocol meta data in `<head />`. And after a quick search, I found `sphinx-socialgraph` just for this addition.

Unfortunately, its generated card image only support default embedded Roboto Flex font file at that time, so any CJK language characters cannot be rendered other than many Tofu ⬜⬜⬜ !

There was an existing issue too: [Bundled Roboto font does not support Japanese (social images) · Issue #108 · wpilibsuite/sphinxext-opengraph](https://github.com/wpilibsuite/sphinxext-opengraph/issues/108)

As the issue explains, the card image is rendered with `matplotlib` but its custom font loading feature was still "TODO" state. As I had some experience with `matplotlib` for a while ago, I somehow could solve the problem to allow the library to load any detectable font file from `matplotlib`.

[The PR is waiting for the review](https://github.com/wpilibsuite/sphinxext-opengraph/pull/110) and hopefully to be merged soon. (later merged on Oct 28, 2023 🎉)

**Before**

![image](https://user-images.githubusercontent.com/1425259/266687384-776f1477-86e5-45f3-acd6-07e39a984092.png)

**After**

![image](https://user-images.githubusercontent.com/1425259/266687274-edb4fae4-5204-4090-81e4-cd0712823654.png)

## Translation rules

While translating docs, I built up the following rules to be consistent:

- place spaces between Japanese and ASCII characters.
- put a space in between multiple Katakana words
  - But "server-side" and "client-side" are concatenated with "-" and they should be treated as one word, so they are translated to "サーバーサイド" and "クライアントサイド" accordingly (not "サーバー サイド")
- behave = 動作する (not 振る舞う)
  - I felt this may help map one word and concept in mind more connected due to the higher density of Kanji characters.
- advanced = 発展的な
- open/close = オープン/クローズ (I though 開く/閉じる is acceptable but オープン is more natural like in the verb "オープンする"
- connection = コネクション、コネクションする (not 接続 or 接続する)
  - both are understandable but the conversion cost of 接続 -> コネクション in brain has a bit more resistance.
- statement = ステートメント, not 文
  - similarly, ステートメント can be mapped to statement more directly, and one might question like "Which 文 means here?"
- use = 使用 (not 利用)
