FROM alpine:3.16.2

LABEL maintainer="Aman Maharjan <mhrznamn068@gmail.com>"

# Deps
RUN apk --no-cache add bash curl jq docker-cli python3 py3-pip unzip

# Kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# AWS CLI
RUN pip install awscli

# Terraform
ENV TF_VERSION="1.3.4"
RUN curl -LO "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv ./terraform /usr/local/bin/terraform \
    && rm terraform_${TF_VERSION}_linux_amd64.zip

# Helm
ENV HELM_VERSION="3.10.1"
RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -xzvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm helm-v${HELM_VERSION}-linux-amd64.tar.gz

