.PHONY: post serve container-serve

post:
	@read -p 'What is the article title? (e.g. hello-world) > ' title; \
	docker run --rm --name "weblog-serve" -p 1313:1313 -v $(CURDIR):/src --workdir /src -e HUGO_WATCH=1 -u $(shell id -u) jojomi/hugo hugo new post/$(shell date +%Y-%m-%d)-$$title.md; \
	idea content/post/$(shell date +%Y-%m-%d)-$$title.md

serve:
	hugo serve --bind=0.0.0.0

container-serve:
	docker run --rm --name "weblog-serve" -p 1313:1313 -v $(CURDIR):/src --workdir /src -e HUGO_WATCH=1 jojomi/hugo \
	hugo serve --buildFuture --buildDrafts --bind 0.0.0.0
