OPENCV_VERSION := $(shell grep OPENCV_VERSION .version | cut -d '=' -f '2')
GOLANG_VERSION := $(shell grep GOLANG_VERSION .version | cut -d '=' -f 2)
PLATFORM := linux/amd64,linux/arm64

opencv:
	docker buildx build --push --platform=$(PLATFORM)	\
		--file=opencv.Dockerfile \
		--tag=querycap/opencv-debian:$(OPENCV_VERSION)-ffmpeg-buster	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.


gocv:
	docker buildx build --push --platform=$(PLATFORM) \
		--file=gocv.Dockerfile \
		--tag=querycap/gocv-debian:$(GOLANG_VERSION)-ffmpeg-buster \
		--build-arg=GOLANG_VERSION=$(GOLANG_VERSION)	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.
