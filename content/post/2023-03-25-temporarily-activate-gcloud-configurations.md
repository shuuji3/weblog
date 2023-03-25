---
title: "Temporarily activate `gcloud` configurations with `CLOUDSDK_ACTIVE_CONFIG_NAME`"
date: 2023-03-25T23:35:52+09:00
tags: ["google-cloud", "gcloud"]
toc: true
---

You can use `CLOUDSDK_ACTIVE_CONFIG_NAME` to switch between multiple configurations temporarily.

<!--more-->

## `gcloud config` for one project

Google Cloud SDK (a.k.a. `gcloud`) can be configured via various config options, such as `gcloud config set project my-gcp-project-123` (set the default Google Cloud project name to `my-gcp-project-123`) and `gcloud config set run/region asia-northeast1` (set the default deploy region of Cloud Run to `asia-northeast1` that is Tokyo region).

But when you need to handle multiple Google Cloud projects or personal/work projects, you have to manage a set of configs.

## `gcloud config configurations` for a set of configs

To switch a set of `gcloud config`, Google Cloud SDK has a useful grouping feature called `configurations` and we can switch between one set of config group and another one.

You can create a `configurations` with `gcloud config configurations` sub-subcommand and can switch a configurations by `gcloud config configurations activate <configurations-name>`.

## Prevent mistake to run command against wrong Google Cloud project

However, I found out that sometimes I forgot to switch back to the previous project and I was about to run a wrong command against different project. That can cause an unwanted incident.

To mitigate the risk of such an incident, you can use a special environment variable `CLOUDSDK_ACTIVE_CONFIG_NAME` so that the specified configurations only within the terminal. If you use the terminal in your editor and the editor has one window for one project, it becomes rare to run wrong `gcloud` command on the other project.

## References

- [Managing gcloud CLI configurations  |  Google Cloud CLI Documentation](https://cloud.google.com/sdk/docs/configurations#activating_a_configuration)
