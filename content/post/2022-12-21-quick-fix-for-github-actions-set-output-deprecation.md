---
title: "Quick fix for GitHub Actions `::set-output::` deprecation using a simple regex"
date: 2022-12-21T21:48:31+09:00
tags: ["github", "github-actions", "regex"]
toc: true
---

<!--more-->

## Problem

Starting 1st June 2023 (planned), GitHub Actions will not support `::set-output name...::` syntax cannot be used.

## Solution

If the command in the workflow file is not complex, you can simply replace the old syntax with the new one using regex like this: `echo "::set-output name=(.+?)::(.+?)"` -> `echo "$1=$2" >> \$GITHUB_OUTPUT`

This regex will replace the command like this:

```yaml
steps:
- run: echo "::set-output name=my-output-variable-key::value"
```

with


```yaml
steps:
- run: echo "my-output-variable-key=value" >> $GITHUB_OUTPUT
```

The previous syntax was quite confusing at first. So while it requires a lot of work by developers around the world, it's a good occasion to refactor it with the cleaner syntax! ✨

## References

- [GitHub Actions: Deprecating save-state and set-output commands | GitHub Changelog](https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/)
