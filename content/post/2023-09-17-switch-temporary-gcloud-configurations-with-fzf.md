---
title: "Switch temporary `gcloud config configurations` with `fzf`"
date: 2023-09-17T22:20:02+09:00
tags: ["gcloud", "fzf"]
toc: true
---

In the previous article [Temporarily activate `gcloud` configurations with `CLOUDSDK_ACTIVE_CONFIG_NAME`](http://localhost:1313/post/2023-03-25-temporarily-activate-gcloud-configurations/), I explained how we can temporarily activate the gcloud configurations. In this post, I will enhance this with `fzf` for the interactive search.

Note that I'm using [🐟 fish shell](https://fishshell.com/).

<!--more-->

## TL;DR

```shell
> alias gcloud-config "export CLOUDSDK_ACTIVE_CONFIG_NAME=(FZF_DEFAULT_COMMAND=\"gcloud config configurations list --format='get(name)'\" fzf --ansi --no-preview)"
```

## Seeking `kubens` usability

I'm using `kubens`'s `fzf` support for several years. `kubens` is accompanied by `kubectx`, a very useful tool when switching a Kubernetes context and namespace easily. And with `fzf`, we can choose the target object from many candidates quickly. `kubens` can be used by just typing `k ns` (I installed another `k` + `*` -> `kubectl ***` expansion shell scripts here) and a few characters, then type the return key.

So I wanted to use the same mechanism for gcloud configurations instead of using searching the shell command history with `Ctrl+R` and rewriting the configurations name every time.

I went a shortcut to see what `kubens` does instead of reading `fzf` documentation. I found out this is just a bash script instead golang program. After all, only code I needed was one statement here:
                                        
```shell
  choice="$(_KUBECTX_FORCE_COLOR=1 \
    FZF_DEFAULT_COMMAND="${SELF_CMD}" \
    fzf --ansi --no-preview || true)"
```
[kubectx/kubens at master · ahmetb/kubectx](https://github.com/ahmetb/kubectx/blob/master/kubens#L117-L119)

By the way, `kubens` was written by [Ahmet Alp Balkan](https://ahmet.im/), who was working at Google Cloud and provided a lot of excellent explanations about GKE and Cloud Run. I've learned a lot from the explanations. I recommend to read [the blog articles](https://ahmet.im/blog/).

## Constructing command

So we can specify `fzf`'s default command like this:

```shell
> FZF_DEFAULT_COMMAND=ls fzf --ansi --no-preview
```

Then, `fzf` takes the output of the specified command (`ls` here) and we can choose the candidates.

Next, let's find a way to list the existing gcloud configurations list without additional information:

```shell
> gcloud config configurations list
NAME               IS_ACTIVE  ACCOUNT                       PROJECT                   COMPUTE_DEFAULT_ZONE  COMPUTE_DEFAULT_REGION
cloud-code         False
default            False      shuuji3@gmail.com             shuuji3                   asia-east1-b          asia-east1
shuuji3            False      shuuji3@gmail.com             shuuji3                   asia-northeast1-a     asia-northeast1
```

This is the starting point. We want to list only the name of the configurations without any headers. After several attempts, I found `get(<field-name>)` was what we need. 

```shell
> gcloud config configurations list --format='get(name)'
cloud-code
default
shuuji3
...
```

Let's specify as the `fzf`'s default command:

```shell
> FZF_DEFAULT_COMMAND=(gcloud config configurations list --format='get(name)') fzf --ansi --no-preview
```

Note that `fzf` returns as an output. So we can set it to the variable.

```shell
> export CLOUDSDK_ACTIVE_CONFIG_NAME=(FZF_DEFAULT_COMMAND="gcloud config configurations list --format='get(name)'" fzf --ansi --no-preview)
```

## Usage example

You can also define this command as a shell alias:

```shell
> alias gcloud-config "export CLOUDSDK_ACTIVE_CONFIG_NAME=(FZF_DEFAULT_COMMAND=\"gcloud config configurations list --format='get(name)'\" fzf --ansi --no-preview)"
```

Then, you can show all the candidates with `gcloud-config` command in this case:

```shell
  shuuji3
  *****************
  *****************
  *****************
  *****************
  *****************
  default
> cloud-code
  8/8 ──────────────────────────────────
>
```

If you type a few characters, you can quickly filter the candidates!

```shell

> default
  1/8 ──────────────────────────────────
> def
```
