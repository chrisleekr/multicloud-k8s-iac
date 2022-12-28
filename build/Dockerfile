FROM alpine:edge

ENV TERRAFORM_VERSION=1.3.6
ENV HELM_VERSION=3.4.1

RUN apk --no-cache add \
  -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  terraform=$TERRAFORM_VERSION \
  helm=$HELM_VERSION \
  bash=5.0.18-r0

