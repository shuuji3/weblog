---
title: "The `docker-credential-desktop` error after installing Colima on macOS"
date: 2022-12-03T11:16:44+09:00
tags: ["colima", "docker"]
toc: true
---

<!--more-->

Previously, I installed Docker Desktop for macOS, but I uninstalled the application since there are still many difficulties to run the aarch64 container on macOS.

This time, I tried the Colima ([abiosoft/colima: Container runtimes on macOS (and Linux) with minimal setup](https://github.com/abiosoft/colima)) though I don't think this solves many issues. But after trying to run the container VM, it started complaining about `docker-credential-desktop` problem.

It was cryptic at first, but I found this is related to the configuration of credential store. The details are described in this documentation: [docker login | Docker Documentation](https://docs.docker.com/engine/reference/commandline/login/#credentials-store).

I had the line `"credsStore": "desktop",` in Docker's `config.json`. Even after uninstalling the Docker Desktop, it seems that the Colima read the config file and try to fetch the credentials from the Docker Desktop, that does not exist anymore.

After all, removing `credsStore` parameter solved the issue. Here's the diff of the `config.json`:

```diff
❯ diff -u ~/.docker/config.json.orig  ~/.docker/config.json
--- /Users/shuuji3/.docker/config.json.orig	2022-12-01 14:24:05.390695225 +0900
+++ /Users/shuuji3/.docker/config.json	2022-12-03 01:52:26.715971379 +0900
@@ -2,7 +2,6 @@
 	"auths": {
 		"https://index.docker.io/v1/": {}
 	},
-	"credsStore": "desktop",
 	"credHelpers": {
 		"asia.gcr.io": "gcloud",
 		"eu.gcr.io": "gcloud",
```
