# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM hadolint/hadolint:v2.13.1-alpine AS hadolint
FROM --platform=$BUILDPLATFORM alpine:3.22

ARG BUILDPLATFORM
ARG BUILDARCH

ARG MINIKUBE_VERSION=1.36.0
ARG GOOGLE_CLOUD_SDK_VERSION=537.0.0
ARG KUBECTL_VERSION=1.34.0
ARG HELM_VERSION=3.18.6
ARG TERRAFORM_VERSION=1.13.1
ARG TASKFILE_VERSION=3.36.0
ARG TRIVY_VERSION=0.66.0

# BUILDPLATFORM=linux/arm64/v8, BUILDARCH=arm64
RUN echo "BUILDPLATFORM=$BUILDPLATFORM, BUILDARCH=$BUILDARCH"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Change to tmp folder
WORKDIR /tmp
# Install dependencies
RUN set -eux; \
    \
    apk add --no-cache \
    ca-certificates=20250619-r0 \
    curl=8.14.1-r1 \
    bash=5.2.37-r0 \
    yq-go=4.46.1-r2 \
    jq=1.8.0-r0 \
    git=2.49.1-r0 \
    python3=3.12.11-r0 \
    py3-pip=25.1.1-r0 \
    pre-commit=4.2.0-r0 \
    shellcheck=0.10.0-r2 \
    && \
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
    curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    mv terraform /usr/local/bin/terraform && \
    terraform version && \
    \
    # Install Taskfile
    sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin v${TASKFILE_VERSION} && \
    \
    # Install trivy - https://github.com/aquasecurity/trivy/releases
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v${TRIVY_VERSION} && \
    \
    # Install tflint
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    \
    # Cleanup
    rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/*

# Move hadolint to /usr/local/bin
COPY --from=hadolint /bin/hadolint /usr/local/bin/hadolint

# Install minikube - Separate layer to speed up builds
RUN apk add --no-cache \
    openssh=10.0_p1-r7 \
    gcompat=1.1.0-r4 \
    iptables=1.8.11-r1 \
    conntrack-tools=1.4.8-r0 \
    && \
    \
    # Install minikube
    curl -LO https://github.com/kubernetes/minikube/releases/download/v${MINIKUBE_VERSION}/minikube-linux-${BUILDARCH} && \
    install minikube-linux-${BUILDARCH} /usr/local/bin/minikube && \
    minikube version && \
    rm -rf minikube-linux-${BUILDARCH} && \
    # Cleanup
    rm -rf /var/cache/apk/*

# Install gcloud - Separate layer to speed up builds
WORKDIR /
ENV PATH="/google-cloud-sdk/bin:$PATH"
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
    find google-cloud-sdk/ -regex ".*/__pycache__" -print0 | xargs -0 rm -rf && \
    rm -rf google-cloud-sdk/.install/.backup \
    google-cloud-sdk/bin/anthoscli \
    google-cloud-sdk/lib/googlecloudsdk/third_party/apis

WORKDIR /srv

COPY container/ /

COPY . .
