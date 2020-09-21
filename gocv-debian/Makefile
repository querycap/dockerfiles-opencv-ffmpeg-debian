GOLANG_VERSION := $(shell grep GOLANG_VERSION .version | cut -d '=' -f 2)

build:
	docker buildx build --push --platform=linux/amd64,linux/arm64 \
		--file=Dockerfile \
		--tag=querycap/gocv-debian:4.3.0-ffmpeg-buster \
		--build-arg=GOLANG_VERSION=$(GOLANG_VERSION)	\
		.
