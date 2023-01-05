# This image is used for running Terraform
FROM alpine:latest

# Set up APK repositories and upgrade
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main git
RUN apk add --no-cache terraform --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk -U upgrade

# Install required tools
RUN apk add --no-cache curl gzip unzip
RUN apk add --no-cache terraform

ENV TFDOCS_VERSION="v0.16.0"
RUN curl -sSLo ./tfdocs-linux-amd64.tar.gz \
        "https://terraform-docs.io/dl/${TFDOCS_VERSION}/terraform-docs-${TFDOCS_VERSION}-linux-amd64.tar.gz" \
		&& gunzip ./tfdocs-linux-amd64.tar.gz \
        && tar xf ./tfdocs-linux-amd64.tar terraform-docs \
        && chmod a+rx ./terraform-docs \
        && rm ./tfdocs-linux-amd64.tar \
        && mv ./terraform-docs /usr/local/bin/terraform-docs

ENV TFSEC_VERSION="v1.28.1"
RUN curl -sSLo /usr/local/bin/tfsec \
    "https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64" \
		&& chmod +x /usr/local/bin/tfsec

ENV TFLINT_VERSION="v0.44.1"
RUN curl -sSLo ./tflint-linux-amd64.zip \
    "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip" \
	    && unzip -u ./tflint-linux-amd64.zip -d . \
        && chmod a+rx ./tflint \
        && mv ./tflint /usr/local/bin/tflint

WORKDIR /terraform-tools
COPY scripts/checker.sh .

ARG account=terraform
RUN addgroup -S ${account} \
    && adduser -S ${account} -G ${account}
USER ${account}:${account}

CMD ["/bin/sh"]
