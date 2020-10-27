FROM golang:1.15-buster AS prepare

ARG VERSION="0.25.0"
RUN git clone --depth 1 -b v${VERSION} https://github.com/hybridgroup/gocv /go/src/gocv.io/x/gocv
WORKDIR /go/src/gocv.io/x/gocv

RUN set -eux; \
    \
    apt-get update; \
    apt-get install sudo -y; \
    \
    make install; \
    \
    rm -rf /var/lib/apt/lists/*

FROM golang:1.15-buster AS onbuild

# ldconfig cache
COPY --from=prepare /etc/ld.so.* /etc/

# lib
COPY --from=prepare /lib /lib
COPY --from=prepare /usr/lib /usr/lib
COPY --from=prepare /usr/local/lib /usr/local/lib

# lib-src
# required for build, no need for runtime
COPY --from=prepare /usr/include /usr/include
COPY --from=prepare /usr/local/include /usr/local/include

COPY --from=prepare /go/src/gocv.io/x/gocv /go/src/gocv.io/x/gocv
RUN cd /go/src/gocv.io/x/gocv && go build -o /go/bin/gocvversion ./cmd/version/main.go && /go/bin/gocvversion

FROM ghcr.io/querycap/distroless/cc-debian10:latest AS runtime

COPY --from=onbuild /etc/ld.so.* /etc/

COPY --from=onbuild /lib /lib
COPY --from=onbuild /usr/lib /usr/lib
COPY --from=onbuild /usr/local/lib /usr/local/lib

# for testing
ONBUILD COPY --from=onbuild /go/bin/gocvversion /go/bin/gocvversion
ONBUILD RUN ["/go/bin/gocvversion"]

# final
# ENTRYPOINT ["/go/bin/app"]
