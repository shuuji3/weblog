---
title: "Install `gcloud` CLI command on Gitpod environment"
date: 2023-10-14T14:38:15Z
tags: ["google-cloud", "gcloud", "gitpod"]
toc: true
---

The empty Gitpod environment does not have `gcloud` command to interact with Google Cloud. So we need to install it by ourselves.

<!--more-->

[Google Cloud documentation](https://cloud.google.com/sdk/docs/install) has good explanation on how to install it on Linux environment, so we can follow that instruction.

It involves adding gpg key for their apt repository to invoke the initial authentication command, so it might be a bit cumbersome for those not familiar with Debian Linux environment or Google Cloud SDK (`gcloud` command) setup.

## Gitpod template repository

You can use this repository I created as a base repository to take a shortcut: [shuuji3/gitpod-workspace-with-gcloud](https://github.com/shuuji3/gitpod-workspace-with-gcloud)

## Installation commands

The entire commands needed for installation are the following five lines: 

```shell
sudo apt-get install -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install -y google-cloud-cli
gcloud auth login
```

### Explanation

This installs the required dependencies. The first two package needs to communicate with the apt repository via HTTPS. And the last one is for GNU Privacy Guard for handling the signing of the apt repository.

```shell
sudo apt-get install -y apt-transport-https ca-certificates gnupg
```

A new apt repository source config file is stored under `/etc/apt/sources.list.d/`. In this case, oneline apt repository information is stored with gpg key information. 

```shell
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```

This download the latest gpg key from Google Cloud and stores it specified by the previous configuration.

```shell
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
```

And then, we install `google-cloud-cli` package which includes `gcloud` cli tool. 

```shell
sudo apt-get update && sudo apt-get install -y google-cloud-cli
```

Finally, we need to be authenticated by Google. This will print out a URL to request an authentication to Google Cloud from our Google account.

```shell
gcloud auth login
```

After being authenticated and entering the authentication code, we can now use `gcloud` and can do whatever you would like to do with Google Cloud!

## References

- [Install the gcloud CLI  |  Google Cloud CLI Documentation](https://cloud.google.com/sdk/docs/install)
