FROM alpine:edge

ENV TERRAFORM_VERSION=0.13.4-r0
ENV HELM_VERSION=3.3.4-r0

RUN apk --no-cache add \
  -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  terraform=$TERRAFORM_VERSION \
  helm=$HELM_VERSION

