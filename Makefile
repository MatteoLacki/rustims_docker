all: image

DOCKERFLAGS = --target rustims --build-arg CACHE_BUST=$$(date +%s) --progress=plain 

image: Dockerfile.amd64
	docker build --file Dockerfile.amd64 --tag matteolacki/rustims:latest $(DOCKERFLAGS) .
	touch image

nobustimage: Dockerfile.amd64
	docker build --file Dockerfile.amd64 --tag matteolacki/rustims:latest --target rustims --progress=plain .
	touch nobustimage

native_arm64_image: Dockerfile.arm64
	docker build --file Dockerfile.arm64 --tag matteolacki/rustims_arm64:latest $(DOCKERFLAGS) .
	touch native_arm64_image

arm64image: Dockerfile.arm64
	echo "Ustable: proceed at your own RISC. We mean no arm."
	docker buildx build --file Dockerfile.arm64 --platform linux/arm64 --tag matteolacki/rustims_arm64:latest $(DOCKERFLAGS) --load .
	touch arm64image

release: install jupyterlab docker-compose.yml imspy_dda releaseReadme.md
	mkdir -p release/inputs
	cp install docker-compose.yml jupyterlab imspy_dda release
	cp releaseReadme.md release/readme.md

release.zip: release
	zip -r release.zip release
