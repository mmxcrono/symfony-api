CONTAINER = symfony-app
DOMAIN = localhost
NAME = symfony-app
REPO = $(DOMAIN)/$(NAME)
LOCAL_TAG = local
LOCAL_REPO_TAG = $(REPO):$(LOCAL_TAG)

.PHONY: build
build:
	docker build --build-arg="INSTALL_XDEBUG=Y" --file=docker/Dockerfile . -t $(LOCAL_REPO_TAG)

.PHONY: run
run:
	docker run --name $(CONTAINER) -d -p 8001:80 \
	--add-host=host.docker.internal:host-gateway \
	-v ./src:/var/www/html \
	 $(LOCAL_REPO_TAG)