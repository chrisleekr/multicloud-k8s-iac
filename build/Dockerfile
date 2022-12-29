FROM alpine:3.17

ENV TERRAFORM_VERSION=1.3.6
ENV HELM_VERSION=3.4.1

RUN apk --no-cache add \
  bash=5.2.15-r0 \
  curl=7.87.0-r0 && \
  # Install Terraform
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  mv terraform /usr/local/bin/ && \
  terraform --version && \
  # Install helm
  curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar xz && \
  mv linux-amd64/helm /usr/bin/helm && \
  chmod +x /usr/bin/helm && \
  rm -rf linux-amd64 && \
  helm version
