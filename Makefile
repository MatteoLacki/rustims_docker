all: image

image: Dockerfile
	docker build --tag rustims --target rustims --build-arg CACHE_BUST=$$(date +%s) --progress=plain .
	touch image

native_arm64_image: Dockerfile.arm64
	docker build --file Dockerfile.arm64 --tag matteolacki/rustims_arm64:latest --target rustims --build-arg CACHE_BUST=$$(date +%s) --progress=plain .
	touch native_arm64_image

nobustimage: Dockerfile.amd64
	docker build --file Dockerfile.amd64 --tag rustims --target rustims .
	touch image

arm64image: Dockerfile.arm64
	docker buildx build --file Dockerfile.arm64 --platform linux/arm64 --tag matteolacki/rustims_arm64:latest --target rustims --build-arg CACHE_BUST=$$(date +%s) --progress=plain --load .
	touch arm64image

release: install jupyterlab docker-compose.yml imspy_dda releaseReadme.md
	mkdir -p release/inputs
	cp install docker-compose.yml jupyterlab imspy_dda release
	cp releaseReadme.md release/readme.md

release.zip: release
	zip -r release.zip release
