#!/usr/bin/env yaml-to-dockerfile

FROM alpine:3.10.2

RUN apk update \
 && apk add --no-cache \
      coreutils \
      python3 \
      py3-yaml

COPY yaml-to-dockerfile /usr/bin/

RUN chmod +x /usr/bin/yaml-to-dockerfile
