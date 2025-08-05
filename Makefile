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

release: install jupyterlab docker-compose.yml imspy_dda releaseReadme.md timsim_configs
	mkdir -p release/inputs
	cp install docker-compose.yml jupyterlab imspy_dda timsim release
	cp -r timsim_configs release/inputs
	cp releaseReadme.md release/readme.md

release_arm64: install_arm64 jupyterlab_arm64 docker-compose.yml imspy_dda_arm64 releaseReadme.md
	mkdir -p release_arm64/inputs
	cp jupyterlab_arm64 release_arm64/jupyterlab
	cp install_arm64 release_arm64/install
	cp timsim_arm64 release_arm64/timsim
	cp imspy_dda_arm64 release_arm64/imspy_dda
	cp docker-compose.yml release_arm64
	cp releaseReadme.md release_arm64/readme.md
	cp -r timsim_configs release/inputs

release.zip: release
	zip -r release.zip release

release_arm64.zip: release_arm64
	zip -r release_arm64.zip release_arm64

