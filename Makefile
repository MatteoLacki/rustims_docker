image: Dockerfile
	docker build --tag rustims --target rustims --build-arg CACHE_BUST=$$(date +%s) .
	touch image

nobustimage: Dockerfile
	docker build --tag rustims --target rustims .
	touch image
