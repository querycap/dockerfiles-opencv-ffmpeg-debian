
#################
#  Go + OpenCV  #
#################
ARG OPENCV_VERSION
ARG GOLANG_VERSION
ARG TARGETARCH

FROM querycap/opencv-debian:$OPENCV_VERSION-ffmpeg-buster AS gocv
LABEL maintainer="hybridgroup"

ENV GOLANG_VERSION $GOLANG_VERSION
RUN apt-get update && apt-get install -y --no-install-recommends \
            git software-properties-common && \
            curl -Lo go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz https://dl.google.com/go/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz && \
            tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz && \
            rm go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz && \
            rm -rf /var/lib/apt/lists/*

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

RUN go get -u -d gocv.io/x/gocv  \
    && cd $GOPATH/src/gocv.io/x/gocv/cmd/version/ \
    && go build -o gocv_version -i main.go

CMD ["./gocv_version"]

