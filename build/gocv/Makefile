VERSION=$(shell cat .version)

NAME ?= gocv-pure
TAG ?= $(VERSION)

prepare:
	@echo ::set-output name=image::$(NAME):$(TAG)
	@echo ::set-output name=build_args::VERSION=$(VERSION)

test:
	docker buildx build \
		--target runtime \
		--push --progress plain \
		--platform=linux/arm64 \
		--file=gocv-pure.Dockerfile \
		--tag=querycap/gocv-pure:$(VERSION)-arm64 \
		--build-arg=VERSION=$(VERSION)	\
    	.