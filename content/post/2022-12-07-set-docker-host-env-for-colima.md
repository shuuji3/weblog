---
title: "Set `DOCKER_HOST` environment variable for Colima"
date: 2022-12-07T22:00:00+09:00
tags: ["docker", "colima", "act"]
toc: true
---

<!--more-->

## Difficulty of non-Docker container tools

Some container tools have assumptions that Docker Desktop is installed on the node and existence of various environment settings set up by Docker Desktop as a de fact setup. So when we use alternative container suite like Colima, we often encountered exception like the tools cannot find the correct information on the container suite.

One of such tools is [`act`](https://github.com/nektos/act), a GitHub Actions clone allows us to test the GitHub Actions on the local machine, which reads `DOCKER_HOST` environment variable to find the container socket. Unfortunately, while the Colima provides us a Docker-compatible socket, its default location is different from Docker, and it does not set up `DOCKER_HOST` by default. That resulted in a failure to run `act` runner container:

```shell
> act
ERRO[0000] failed to obtain container engine info: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running? 
[github pages/deploy] 🚀  Start image=catthehacker/ubuntu:act-18.04
[github pages/deploy]   🐳  docker pull image=catthehacker/ubuntu:act-18.04 platform=linux/amd64 username= forcePull=false
Error: unable to determine if image already exists for image 'catthehacker/ubuntu:act-18.04' (linux/amd64): Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

where the path `unix:///var/run/docker.sock` is the default socket location of the Docker Desktop.

## Find Colima's Docker socket path

Since Colima v0.4.0+ uses `$HOME/.colima/default/docker.sock` (previously, `$HOME/.colima/docker.sock`) as a location of the docker socket equivalent. You can check the socket path by running `colima status` [^colima-faq]:

[^colima-faq]: [colima/FAQ.md at main · abiosoft/colima · GitHub](https://github.com/abiosoft/colima/blob/main/docs/FAQ.md#docker-socket-location)

```shell
> colima status
INFO[0000] colima is running
INFO[0000] arch: aarch64
INFO[0000] runtime: docker
INFO[0000] mountType: sshfs
INFO[0000] socket: unix:///Users/<user-name>/.colima/default/docker.sock
```

Also, the `docker context ls` printouts the list of docker contexts:

```shell
> docker context ls
NAME            DESCRIPTION                               DOCKER ENDPOINT                                     KUBERNETES ENDPOINT   ORCHESTRATOR
colima          colima                                    unix:///Users/<user-name>/.colima/default/docker.sock                         
default         Current DOCKER_HOST based configuration   unix:///var/run/docker.sock                                               swarm
```

## Export `DOCKER_HOST` environment variable programmatically

We can get the correct path of `colima` context by combining `docker`'s JSON output and `jq`:

```shell
> docker context inspect colima | jq -r '.[0].Endpoints.docker.Host'
unix:///Users/<user-name>/.colima/default/docker.sock
```

Now, we can export `DOCKER_HOST` with this command:

```shell
> export DOCKER_HOST=(docker context inspect colima | jq -r '.[0].Endpoints.docker.Host')
> printenv DOCKER_HOST
unix:///Users/<user-name>/.colima/default/docker.sock
```
