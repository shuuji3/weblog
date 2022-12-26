---
title: "Useful preinstalled `proxy_params` nginx config"
date: 2022-12-26T22:41:13+09:00
tags: ["nginx"]
toc: true
---

<!--more-->

At least the Ubuntu nginx package installs `/etc/nginx/proxy_params`, which contains the idiomatic proxy forwarding header config like the one below so we don't have to write them manually!

```conf
proxy_set_header Host $http_host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
```

This proxy_params can be inserted by writing just one derective `include proxy_params;`. So the minimal proxy config for nginx would be something like this:

```conf
server {
	listen 80;
	listen [::]:80;

	server_name example.com;

	location / {
		 proxy_pass http://localhost:3000;
		 include proxy_params;
	}
}
```
