ARG GOLANG_VERSION
ARG OPENCV_VERSION

FROM golang:$GOLANG_VERSION-buster as golang
FROM querycap/opencv-debian:$OPENCV_VERSION-ffmpeg-buster-$TARGETARCH as opencv

FROM debian:buster-slim
ARG OPENCV_VERSION
ENV OPENCV_VERSION=$OPENCV_VERSION
ENV VERSION="2020-11-19"

RUN sed -i '/security/d' /etc/apt/sources.list 

RUN apt-get update && apt-get install -y    \
        curl \
        bash \
    && rm -rf /var/lib/apt/lists/*

## opencv
RUN apt-get update && apt-get install -y    \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

ENV OPENCV_VERSION $OPENCV_VERSION
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
            ca-certificates \
            pkg-config \
            libcurl4-openssl-dev \
            libssl-dev \
            libavcodec-dev \
            libavformat-dev \
            libtbb2 \
            libtbb-dev \
            libjpeg-dev \
            libpng-dev \
            libtiff-dev \
            libdc1394-22-dev \
            libdc1394-22 \
            libgtk2.0 \
            libswscale-dev \
            libpq-dev \
            libavcodec58    \
    && rm -rf /var/lib/apt/lists/*

COPY --from=opencv /usr/local/include/opencv4 /usr/local/include/opencv4
COPY --from=opencv /usr/local/lib /usr/local/lib
# COPY ldconfig/opencv.conf /etc/ld.so.conf.d/opencv.conf
RUN echo "/usr/local/include/opencv4" >> /etc/ld.so.conf.d/opencv.conf \
    && echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf \
    && ldconfig

ENV CGO_CPPFLAGS "-I/usr/local/include"
ENV CGO_LDFLAGS "-L/usr/local/lib -lopencv_core -lopencv_face -lopencv_videoio -lopencv_imgproc -lopencv_highgui -lopencv_imgcodecs -lopencv_objdetect -lopencv_features2d -lopencv_video -lopencv_dnn -lopencv_xfeatures2d"
ENV CGO_ENABLED 1

# golang
COPY --from=golang /usr/local/go/lib /usr/local/go/lib
ENV GOROOT=/go \
    GOPATH=/go/src \
    GODEBUG=netdns=cgo

WORKDIR /etc/service
