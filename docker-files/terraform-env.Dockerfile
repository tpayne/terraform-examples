# This image is used for running Terraform
FROM alpine:latest

# Set up APK repositories and upgrade
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main git
RUN apk -U upgrade

# Install required tools
RUN apk add --no-cache curl gzip unzip wget unzip libc6-compat
RUN apk add --no-cache \
            ca-certificates \
            less \
            ncurses-terminfo-base \
            krb5-libs \
            libgcc \
            libintl \
            libstdc++ \
            tzdata \
            userspace-rcu \
            zlib \
            icu-libs
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
            lttng-ust

# renovate: datasource=github-releases terraform-linters/tflint
ENV TF_VERSION="1.9.7"
RUN curl -sSLo ./terraform-linux-amd64.zip \
    "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" \
	    && unzip -u ./terraform-linux-amd64.zip -d . \
        && chmod a+rx ./terraform \
        && mv ./terraform /usr/local/bin/terraform

# renovate: datasource=github-releases depName=terraform-docs/terraform-docs
ENV TFDOCS_VERSION="v0.16.0"
RUN curl -sSLo ./tfdocs-linux-amd64.tar.gz \
        "https://terraform-docs.io/dl/${TFDOCS_VERSION}/terraform-docs-${TFDOCS_VERSION}-linux-amd64.tar.gz" \
		&& gunzip ./tfdocs-linux-amd64.tar.gz \
        && tar xf ./tfdocs-linux-amd64.tar terraform-docs \
        && chmod a+rx ./terraform-docs \
        && rm ./tfdocs-linux-amd64.tar \
        && mv ./terraform-docs /usr/local/bin/terraform-docs

# renovate: datasource=github-releases depName=aquasecurity/tfsec
ENV TFSEC_VERSION="v1.28.1"
RUN curl -sSLo /usr/local/bin/tfsec \
    "https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64" \
		&& chmod +x /usr/local/bin/tfsec

# renovate: datasource=github-releases terraform-linters/tflint
ENV TFLINT_VERSION="v0.44.1"
RUN curl -sSLo ./tflint-linux-amd64.zip \
    "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip" \
	    && unzip -u ./tflint-linux-amd64.zip -d . \
        && chmod a+rx ./tflint \
        && mv ./tflint /usr/local/bin/tflint

# Download the powershell '.tar.gz' archive
# renovate: datasource=github-releases depName=PowerShell/PowerShell extractVersion=^v-(?<version>.*)$
ENV PSH_VERSION="7.3.0"
RUN curl -sSLo /tmp/powershell.tar.gz \
    "https://github.com/PowerShell/PowerShell/releases/download/v${PSH_VERSION}/powershell-${PSH_VERSION}-linux-alpine-x64.tar.gz" \
        && mkdir -p /opt/microsoft/powershell/7 \
        && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
        && chmod +x /opt/microsoft/powershell/7/pwsh \
        && ln -s /opt/microsoft/powershell/7/pwsh /usr/local/bin/pwsh

WORKDIR /terraform-tools
COPY scripts/checker.sh .

RUN curl -sSLo /tmp/tool.zip \
    "https://aka.ms/arm-ttk-latest" \
        && mkdir -p arm-template-toolkit \
        && unzip -u /tmp/tool.zip -d ./arm-template-toolkit/ \
        && echo '#!/bin/sh' > ./arm-template-toolkit/runcmd.sh \
        && chmod a+rx ./arm-template-toolkit/runcmd.sh \
        && echo "cd arm-ttk/" >> ./arm-template-toolkit/runcmd.sh \
        && echo 'pwsh << EOF' >> ./arm-template-toolkit/runcmd.sh \
        && echo "Get-ChildItem *.ps1, *.psd1, *.ps1xml, *.psm1 -Recurse | Unblock-File" \
                >> ./arm-template-toolkit/runcmd.sh \
        && echo "Import-Module ./arm-ttk.psd1"  \
                >> ./arm-template-toolkit/runcmd.sh \
        && echo 'EOF' >> ./arm-template-toolkit/runcmd.sh

# Account name
ARG account=terraform
RUN addgroup -S ${account} \
    && adduser -S ${account} -G ${account}
USER ${account}:${account}

CMD ["/bin/sh"]
