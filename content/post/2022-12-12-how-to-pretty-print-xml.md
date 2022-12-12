---
title: "How to pretty print XML document?"
date: 2022-12-12T23:04:10+09:00
tags: ["xml", "yaml", "yq", "cli"]
toc: true
---

<!--more-->

## `jq` for JSON, `yq` for YAML and XML

When I want to see the beautifully formatted JSON string in a terminal, I usually use the popular `jq` command line tool.

How about XML documentation? We can use the `yq` command line tool, which is the `jq`-equivalent tool for YAML format, to reformat it. Thanks to the author, the `yq` supports not only YAML format but also XML format.

## XML -> YAML output

So we can simply convert the XML format to the YAML for evaluation like this:

```shell
> curl https://example.com/@admin@example.com/rss/ | yq -p=xml
```

```yaml
rss:
  +version: "2.0"
  +xmlns:atom: http://www.w3.org/2005/Atom
  channel:
    title: admin
    link:
      - https://example.com/@admin/
      - +href: https://example.com/@admin@example.com/rss/
        +rel: self
    description: Public posts from @admin@example.com
    language: en-us
    lastBuildDate: Sun, 12 Dec 2022 14:00:00 +0000
    item:
      - title: 'admin@example.com #1'
        link: https://example.com/@admin/posts/1/
        description: "<p>Hello, takahē RSS!</p>"
        pubDate: Sun, 12 Dec 2022 14:00:00 +0000
        guid: https://example.com/@admin/posts/1/
```

## XML -> XML output

Or, if you want to see in the XML format, you can specify `-o=xml` option to output as XML format:

```shell
> curl https://example.com/@admin@example.com/rss/ | yq -p=xml -o=xml
```

```xml
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>admin</title>
    <link>https://example.com/@admin/</link>
    <link href="https://example.com/@admin@example.com/rss/" rel="self"></link>
    <description>Public posts from @admin@example.com</description>
    <language>en-us</language>
    <lastBuildDate>Sun, 12 Dec 2022 14:00:00 +0000</lastBuildDate>
    <item>
      <title>admin@example.com #1</title>
      <link>https://example.com/@admin/posts/1/</link>
      <description>&lt;p&gt;Hello, takahē RSS!&lt;/p&gt;</description>
      <pubDate>Sun, 12 Dec 2022 14:00:00 +0000</pubDate>
      <guid>https://example.com/@admin/posts/1/</guid>
    </item>
  </channel>
</rss>
```

## References

- [xq is missing for mac installation · Issue #491 · mikefarah/yq](https://github.com/mikefarah/yq/issues/491#issuecomment-1019010160)
- [Working with XML - yq](https://mikefarah.gitbook.io/yq/usage/xml)
