FROM alpine:3.7

ARG NETLIFYCTL_VERSION=0.4.0
ENV MIX_ENV=dev PORT=4000 WORKDIR=/usr/src/app APPSIGNAL_BUILD_FOR_MUSL=1 REPLACE_OS_VARS=true

RUN set -x \
  && mkdir -p "${WORKDIR}" /usr/local/bin \
  && apk add --update --upgrade --no-cache --virtual .dockerize-packages \
    ca-certificates wget \
  && wget "https://github.com/netlify/netlifyctl/releases/download/v${NETLIFYCTL_VERSION}/netlifyctl-linux-amd64-${NETLIFYCTL_VERSION}.tar.gz" \
  && tar -C /usr/local/bin -xzvf "netlifyctl-linux-amd64-${NETLIFYCTL_VERSION}.tar.gz" \
  && rm "dockerize-alpine-linux-amd64-${NETLIFYCTL_VERSION}.tar.gz" \
  && apk del .dockerize-packages \
  && apk add --no-cache --virtual .build-packages \
    build-base curl ca-certificates \
  && rm -rf /var/cache/apk/*

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

EXPOSE 4000
