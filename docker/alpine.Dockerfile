FROM alpine:latest as build

ARG TDLIB_TREE
RUN apk update && apk upgrade --update-cache --available && \
    apk add --update --virtual .dev-deps alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake && \
    git clone https://github.com/tdlib/td.git /td && \
    cd /td && \
    git reset --hard ${TDLIB_TREE} && \
    rm -rf build && mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. && \
    cmake --build . --target install && \
    rm -rf /td && \
    apk del .dev-deps

FROM scratch as artifact

ARG TDLIB_VERSION
COPY --from=build /usr/local/lib/libtdjson.so /${TDLIB_VERSION}/libtdjson.so
