ARG OPENCV_VERSION
ARG TARGETARCH
FROM querycap/opencv-debian:$OPENCV_VERSION-ffmpeg-buster-$TARGETARCH AS gocv

LABEL maintainer="querycap"

ARG GOLANG_VERSION
ARG TARGETARCH
ENV GOLANG_VERSION $GOLANG_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
            git software-properties-common && \
            rm -rf /var/lib/apt/lists/*

RUN set -eux; curl -o go.tgz -fsSL https://dl.google.com/go/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz && \
            tar -C /usr/local -xf go.tgz && \
            rm go.tgz
            

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

RUN go get -u -d gocv.io/x/gocv  \
    && cd $GOPATH/src/gocv.io/x/gocv/cmd/version/ \
    && go build -o /usr/bin/gocv_version -i main.go

CMD ["/usr/bin/gocv_version"]

