FROM alpine:3.20.3

LABEL maintainer="Aman Maharjan <mhrznamn068@gmail.com>"

ARG TF_VERSION="1.9.5"
ARG TG_VERSION="0.67.4"
ARG HELM_VERSION="3.15.0"

# Deps
RUN apk --no-cache add bash curl jq docker-cli python3 py3-pip unzip openssh-client git wget ca-certificates gnupg gettext \
    && apk --no-cache add --virtual build-dependencies python3-dev libffi-dev openssl-dev build-base \
    && pip3 install --upgrade pip \
    && apk del build-dependencies \
    ## Kubectl
    && curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    ## AWS CLI
    && pip install awscli \
    RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install \
    && rm awscliv2.zip \
    ## Terraform
    && curl -LO "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv ./terraform /usr/local/bin/terraform \
    && rm terraform_${TF_VERSION}_linux_amd64.zip \
    ## Terragrunt
    curl -o terragrunt "https://objects.githubusercontent.com/github-production-release-asset-2e65be/59522149/28e8ee72-2df4-4704-8f99-5d607dfce652?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20240329%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240329T062143Z&X-Amz-Expires=300&X-Amz-Signature=d931352b396cd18e168e84cd92b0ef595a1ce6e962e50fcf4e646f562f55026b&X-Amz-SignedHeaders=host&actor_id=38400817&key_id=0&repo_id=59522149&response-content-disposition=attachment%3B%20filename%3Dterragrunt_linux_amd64&response-content-type=application%2Foctet-stream" \
    && chmod +x terragrunt \
    && mv terragrunt /usr/local/bin/terragrunt \
    ## Helm
    && curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -xzvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm helm-v${HELM_VERSION}-linux-amd64.tar.gz

# Clean up build dependencies and caches
RUN apk del gcc musl-dev libffi-dev && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/*

