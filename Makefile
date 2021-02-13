serve:
	docker run --rm --name "weblog-serve" -p 3000:1313 -v $(CURDIR):/src --volume /tmp/hugo-build-output:/output -w /src -e HUGO_WATCH=1 jojomi/hugo hugo serve --buildFuture --bind 0.0.0.0
