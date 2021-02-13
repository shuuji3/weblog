serve:
	docker run --rm --name "weblog-serve" -p 1313:1313 -v $(CURDIR):/src --workdir /src -e HUGO_WATCH=1 jojomi/hugo \
	hugo serve --buildFuture --buildDrafts --bind 0.0.0.0 --baseURL $(shell gp url 1313) --appendPort=false
