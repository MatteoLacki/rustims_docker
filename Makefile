all: image

image: Dockerfile
	docker build --tag rustims --target rustims --build-arg CACHE_BUST=$$(date +%s) .
	touch image

nobustimage: Dockerfile
	docker build --tag rustims --target rustims .
	touch image

arm64image: Dockerfile
	@docker buildx ls | grep -q rustimsbuilder || docker buildx create --name rustimsbuilder --use
	docker buildx build --platform linux/arm64 --tag rustims --target rustims --build-arg CACHE_BUST=$$(date +%s) --load .
	touch arm64image

release: install jupyterlab docker-compose.yml imspy_dda releaseReadme.md
	mkdir -p release/inputs
	cp install docker-compose.yml jupyterlab imspy_dda release
	cp releaseReadme.md release/readme.md

release.zip: release
	zip -r release.zip release
