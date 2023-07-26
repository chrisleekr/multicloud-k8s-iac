# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM alpine:3.18

ARG BUILDPLATFORM
ARG BUILDARCH

ARG MINIKUBE_VERSION=1.31.0
ARG CRICTL_VERSION=1.26.0
ARG CRI_DOCKERD_VERSION=0.3.4
ARG CNI_PLUGINS_VERSION=1.3.0
ARG GOOGLE_CLOUD_SDK_VERSION=438.0.0
ARG KUBECTL_VERSION=1.27.3
ARG HELM_VERSION=3.12.2
ARG TERRAFORM_VERSION=1.5.3

# BUILDPLATFORM=linux/arm64/v8, BUILDARCH=arm64
RUN echo "BUILDPLATFORM=$BUILDPLATFORM, BUILDARCH=$BUILDARCH"

COPY container-files/ /

# Install dependencies
RUN set -eux; \
    \
    apk add --no-cache \
    ca-certificates=20230506-r0 \
    curl=8.2.1-r0 \
    bash=5.2.15-r5 \
    yq=4.33.3-r1 \
    jq=1.6-r3 \
    git=2.40.1-r0 \
    python3=3.11.4-r0 \
    && \
    # Change to tmp folder
    cd /tmp && \
    \
    # Install kubectl
    curl -L https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${BUILDARCH}/kubectl \
    -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --short || true && \
    \
    # Install Helm
    curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-${BUILDARCH}.tar.gz | tar xz && \
    mv linux-${BUILDARCH}/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-${BUILDARCH} && \
    helm version && \
    \
    # Install Terraform
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    mv terraform /usr/local/bin/terraform && \
    terraform version && \
    \
    # Cleanup
    rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/*

# Install minikube - Separate layer to speed up builds
RUN apk add --no-cache \
    openssh=9.3_p2-r0 \
    gcompat=1.1.0-r1 \
    libc6-compat=1.2.4-r0 \
    iptables=1.8.9-r2 \
    conntrack-tools=1.4.7-r1 \
    && \
    \
    # Install minikube
    curl -LO https://github.com/kubernetes/minikube/releases/download/v${MINIKUBE_VERSION}/minikube-linux-${BUILDARCH} && \
    install minikube-linux-${BUILDARCH} /usr/local/bin/minikube && \
    minikube version && \
    rm -rf minikube-linux-${BUILDARCH} && \
    \
    # Install crictl
    wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CRICTL_VERSION}/crictl-v${CRICTL_VERSION}-linux-${BUILDARCH}.tar.gz && \
    tar zxvf crictl-v${CRICTL_VERSION}-linux-${BUILDARCH}.tar.gz -C /usr/local/bin && \
    rm -f crictl-v${CRICTL_VERSION}-linux-${BUILDARCH}.tar.gz && \
    \
    # Install cri-dockerd
    curl -sSfLo /tmp/cri-dockerd.tgz https://github.com/Mirantis/cri-dockerd/releases/download/v${CRI_DOCKERD_VERSION}/cri-dockerd-${CRI_DOCKERD_VERSION}.${BUILDARCH}.tgz \
    && tar xf /tmp/cri-dockerd.tgz --directory /tmp/ \
    && mv /tmp/cri-dockerd/cri-dockerd /usr/local/bin/cri-dockerd \
    && rm -rf /tmp/cri-dockerd \
    && chmod 755 /usr/local/bin/cri-dockerd && \
    \
    # Install containernetworking-plugins
    # https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-arm64-v1.3.0.tgz
    curl -LO "https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-${BUILDARCH}-v${CNI_PLUGINS_VERSION}.tgz" && \
    mkdir -p /opt/cni/bin && \
    tar -xf "cni-plugins-linux-${BUILDARCH}-v${CNI_PLUGINS_VERSION}.tgz" -C /opt/cni/bin && \
    rm "cni-plugins-linux-${BUILDARCH}-v${CNI_PLUGINS_VERSION}.tgz" && \
    # Create folder for CNI config
    mkdir -p /etc/cni/net.d && \
    # Cleanup
    rm -rf /var/cache/apk/*

# Install gcloud - Separate layer to speed up builds
ENV PATH /google-cloud-sdk/bin:$PATH
RUN export GOOGLE_CLOUD_SDK_ARCH="x86_64"; \
    if [ "$BUILDARCH" = "arm64" ]; then \
        export GOOGLE_CLOUD_SDK_ARCH="arm"; \
    fi; \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GOOGLE_CLOUD_SDK_VERSION}-linux-${GOOGLE_CLOUD_SDK_ARCH}.tar.gz && \
    tar xzf google-cloud-cli-${GOOGLE_CLOUD_SDK_VERSION}-linux-${GOOGLE_CLOUD_SDK_ARCH}.tar.gz && \
    rm google-cloud-cli-${GOOGLE_CLOUD_SDK_VERSION}-linux-${GOOGLE_CLOUD_SDK_ARCH}.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud --version && \
    gcloud components install gke-gcloud-auth-plugin && \
    # Google Cloud CLI cleanup
    rm -rf $(find google-cloud-sdk/ -regex ".*/__pycache__") \
    google-cloud-sdk/.install/.backup \
    google-cloud-sdk/bin/anthoscli \
    google-cloud-sdk/lib/googlecloudsdk/third_party/apis




WORKDIR /srv

COPY . .
