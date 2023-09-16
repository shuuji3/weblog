---
title: "Taiwanese Character Encoding: Big5? EUC-TW? CCCII?"
date: 2023-09-16T16:02:49+09:00
tags: ["encoding", "taiwanese", "japanese"]
toc: true
---

When I was checking the electricity production data in Taiwan from Taipower (台湾電力公司) website for [this issue](https://github.com/electricitymaps/electricitymaps-contrib/issues/5903), I encountered a character encoding issue.

<!--more-->

Here's an example output from https://www.taipower.com.tw/d006/loadGraph/loadGraph/data/genary.txt.

```json
{
    "": "2023-09-16 15:00",
    "aaData": [
        [
            "<A NAME='nuclear'></A><b>�瓲��(Nuclear)</b>",
            "",
            "�瓲銝�#1",
            "951.0",
            "943.8",
            "99.243%",
            " "
        ],
...
```

Yes, this is apparently Moji-bake. I've only had experience in Japanese encoding. So I couldn't point out what is the original encoding from Moji-bake'd characters.

For Japanese, very old legacy sites, or ones made by outdated organizations, still sometimes uses non-UTF-8 encoding in this era! The common encodings are "Shift JIS" (or [Windows modified version of it called CP932](https://en.wikipedia.org/wiki/Code_page_932_(Microsoft_Windows)) and "EUC-JP", that was used by old Japanese Linux environment. And Moji-bake has visual characteristics for each encoding, so if someone have certain exposure for them, they could say which encoding just looking at it.

[There seems several common old encodings for Chinese characters in Taiwanese](https://docs.mojolicious.org/Encode/TW) like Japanese. In this case, the answer was not "Big5" but "EUC-TW". 🎉

```json
{
    "": "2023-09-16 15:00",
    "aaData": [
        [
            "<A NAME='nuclear'></A><b>核能(Nuclear)</b>",
            "",
            "核三#1",
            "951.0",
            "943.8",
            "99.243%",
            " "
        ],
...
```
