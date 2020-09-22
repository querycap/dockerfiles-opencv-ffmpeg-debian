
#################
#  Go + OpenCV  #
#################
ARG OPENCV_VERSION
FROM querycap/opencv-debian:$OPENCV_VERSION-ffmpeg-buster AS gocv
LABEL maintainer="hybridgroup"

ARG GOVERSION="1.15"
ENV GOVERSION $GOVERSION

ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
            git software-properties-common && \
            curl -Lo go${GOVERSION}.linux-${TARGETARCH}.tar.gz https://dl.google.com/go/go${GOVERSION}.linux-${TARGETARCH}.tar.gz && \
            tar -C /usr/local -xzf go${GOVERSION}.linux-${TARGETARCH}.tar.gz && \
            rm go${GOVERSION}.linux-${TARGETARCH}.tar.gz && \
            rm -rf /var/lib/apt/lists/*

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

RUN go get -u -d gocv.io/x/gocv  \
    && cd $GOPATH/src/gocv.io/x/gocv/cmd/version/ \
    && go build -o gocv_version -i main.go

CMD ["./gocv_version"]

