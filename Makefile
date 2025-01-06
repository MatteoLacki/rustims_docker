PATH_TO_PRIVATE_SSH_KEY?=$(HOME)/.ssh/id_rsa

default:
	echo "This Makefile is not meant for end-users. Follow the README."

all:
	echo "docker run -h midia_docker -it -v $(realpath spectra):/midia/midia_experiments/midia_workspace/midia_pipe/spectra -v $(realpath outputs):/midia/midia_experiments/midia_workspace/midia_pipe/outputs -v $(realpath partial):/midia/midia_experiments/midia_workspace/midia_pipe/P midia snakemake -call"

dockerhub: cleandockerhub install.sh run.sh run_regression.sh run_regression_inside_docker.sh SIMPLEREADME.md REGRESSION_README.md
	mkdir -p dockerhub/configs
	mkdir -p dockerhub/fastas
	mkdir -p dockerhub/midia_dev
	mkdir -p dockerhub/outputs
	mkdir -p dockerhub/P
	mkdir -p dockerhub/partial
	mkdir -p dockerhub/snakemake
	mkdir -p dockerhub/spectra
	mkdir -p dockerhub/spectra/None.d
	touch dockerhub/spectra/None.d/analysis.tdf{,_bin}
	cp docker-compose.yml install.sh run.sh dockerhub
	cp SIMPLEREADME.md dockerhub/README.md
	cp run_regression.sh REGRESSION_README.md dockerhub
	cp run_regression_inside_docker.sh dockerhub/partial

dockerhub.zip: dockerhub
	rm dockerhub.zip | true
	zip -r dockerhub.zip dockerhub

cleandockerhub:
	rm -rf dockerhub dockerhub.zip

clean: cleandockerhub 
	docker run -h midia_docker -it -v $(realpath spectra):/midia/midia_experiments/midia_workspace/midia_pipe/spectra -v $(realpath outputs):/midia/midia_experiments/midia_workspace/midia_pipe/outputs -v $(realpath partial):/midia/midia_experiments/midia_workspace/midia_pipe/P midia bash -c "rm -rf P/* outputs/* configs/*"

image: midia_config.toml Dockerfile midia_config_prefetch_cache.toml
	echo "#LAST DOCKER BUILD: $$(date)" >> midia_config.toml
	docker build --tag midia --target midia --secret id=ssh_key,source=$(PATH_TO_PRIVATE_SSH_KEY)  .
	touch image

open_image: midia_config.toml Dockerfile midia_config_prefetch_cache.toml
	echo "#LAST DOCKER BUILD: $$(date)" >> midia_config.toml
	docker build --tag midia_open --target midia_open --secret id=ssh_key,source=$(PATH_TO_PRIVATE_SSH_KEY)  .
	touch open_image

image_no_cache: midia_config.toml Dockerfile midia_config_prefetch_cache.toml
	echo "#LAST DOCKER BUILD: $$(date)" >> midia_config.toml
	docker build --tag midia --target midia --secret id=ssh_key,source=$(PATH_TO_PRIVATE_SSH_KEY) --no-cache .
	touch image_no_cache

midia_image.tar.xz: image
	docker save midia | pixz -c > midia_image.tar.xz

devel_image: midia_config.toml Dockerfile midia_config_prefetch_cache.toml
	echo "#LAST DOCKER BUILD: $$(date)" >> midia_config.toml
	docker build --tag midia_dev --target midia_dev --secret id=ssh_key,source=$(PATH_TO_PRIVATE_SSH_KEY) .
	docker compose run -u $(id -u):$(id -g) midia_dev /bin/bash -c "cp -r /midia/* /midia_dev"
	touch devel_image

