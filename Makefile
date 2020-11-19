OPENCV_VERSION := $(shell grep OPENCV_VERSION .version | cut -d '=' -f '2')
GOLANG_VERSION := $(shell grep GOLANG_VERSION .version | cut -d '=' -f 2)
PLATFORM := linux/amd64,linux/arm64

opencv:
	docker buildx build --push --platform=$(PLATFORM)	\
		--file=merge.Dockerfile \
		--tag=querycap/opencv-debian:$(OPENCV_VERSION)-ffmpeg-buster	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.

opencv.base-amd64:
	docker buildx build --push --platform=linux/amd64	\
		--file=opencv.Dockerfile \
		--tag=querycap/opencv-debian:$(OPENCV_VERSION)-ffmpeg-buster-amd64	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.

opencv.base-arm64:
	docker buildx build --push --platform=linux/arm64	\
		--file=opencv.Dockerfile \
		--tag=querycap/opencv-debian:$(OPENCV_VERSION)-ffmpeg-buster-amd64	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.


gocv:
	docker buildx build --push --progress plain \
		--platform=$(PLATFORM) \
		--file=gocv.Dockerfile \
		--tag=querycap/gocv-debian:$(GOLANG_VERSION)-ffmpeg-buster \
		--build-arg=GOLANG_VERSION=$(GOLANG_VERSION)	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.

opencv.runtime:
	docker buildx build --push \
		--platform=$(PLATFORM)	\
		--file=runtime.Dockerfile  \
		--tag=querycap:/opencv-debian:runtime-$(OPENCV_VERSION)-go$(GOLANG_VERSION) \
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		--build-arg=GOLANG_VERSION=$(GOLANG_VERSION)	\
