---
title: Construct Name With Bash Substitution in GitHub Actions
date: 2022-12-03T00:30:14+09:00
tags: ["github-actions", "bash"]
toc: true
---

How we can construct string like `2022-12-03-refs-heads-feature-branch-1-1234abc` in GitHub Actions?

<!--more-->

We can use several predefined environment variables in the GitHub Actions environment. They are described in the documentation: [Environment variables - GitHub Docs](https://docs.github.com/en/actions/learn-github-actions/environment-variables#default-environment-variables).

This string `2022-12-03-refs-heads-feature-branch-1-1234abc` can be divided into three parts: today's date, the reference name (like `refs-heads-feature-branch-1`), and git commit hash (`1234abc`).

The date can be created from `date` command. The reference name can be created from `GITHUB_REF` (like `refs/heads/feature-branch-1`). The commit hash can be created from `GITHUB_SHA` (like `ffac537e6cbbf934b08745a378932722df287a53`). 

The `date` should be OK, but other environment variables contains illegal characters for the filename or too long. In the normal GitHub Workflow environment (Ubuntu VM?), it looks like we can use a bash's feature called [Shell Parameter Expansion (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html).

To make the desired string `2022-12-03-refs-heads-feature-branch-1-1234abc`, we can use the  expression like this: `$(date +%Y-%m-%d)-${GITHUB_REF////-}-${GITHUB_SHA::7}`. The `${VARIABLE//A/B}` means to replace `A` with `B` in `VARIABLE` and the `${VARIABLE:0:7}` means to substring `VARIABLE` from position 0 (which can be omitted) to position 7.
