FROM alpine:edge

ENV TERRAFORM_VERSION=0.13.5-r0
ENV HELM_VERSION=3.4.0-r0

RUN apk --no-cache add \
  -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  terraform=$TERRAFORM_VERSION \
  helm=$HELM_VERSION \
  bash=5.0.18-r0

