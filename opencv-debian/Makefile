OPENCV_VERSION := $(shell grep OPENCV_VERSION .version | cut -d '=' -f '2')

build:
	docker buildx build --push --platform=linux/amd64,linux/arm64 \
		--file=Dockerfile \
		--tag=querycap/querycap/opencv-debian:4.3.0-ffmpeg-buster	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.