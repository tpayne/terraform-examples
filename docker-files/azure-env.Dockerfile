# This image is used for running Terraform
FROM alpine:latest

# Set up APK repositories and upgrade
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main git
RUN apk -U upgrade

# Install required tools
RUN apk add --no-cache curl gzip unzip
RUN apk add --no-cache \
            ca-certificates \
            less \
            ncurses-terminfo-base \
            krb5-libs \
            libgcc \
            libintl \
            libssl1.1 \
            libstdc++ \
            tzdata \
            userspace-rcu \
            zlib \
            icu-libs \
            gcc \
            musl-dev \
            python3-dev \
            libffi-dev\
            openssl-dev \
            cargo \
            make \
            py3-pip
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
            lttng-ust

# renovate: datasource=github-releases depName=Azure/bicep extractVersion=^v-(?<version>.*)$
ENV BICEP_VERSION="v0.13.1"
RUN curl -sSLo ./bicep-linux-arm64 \
        "https://github.com/Azure/bicep/releases/download/v${BICEP_VERSION}/bicep-linux-arm64" \
		&& chmod a+rx ./bicep-linux-arm64 \
        && mv ./bicep-linux-arm64 /usr/local/bin/bicep

# Download the powershell '.tar.gz' archive
# renovate: datasource=github-releases depName=PowerShell/PowerShell extractVersion=^v-(?<version>.*)$
ENV PSH_VERSION="7.3.0"
RUN curl -sSLo /tmp/powershell.tar.gz \
    "https://github.com/PowerShell/PowerShell/releases/download/v${PSH_VERSION}/powershell-${PSH_VERSION}-linux-alpine-x64.tar.gz" \
        && mkdir -p /opt/microsoft/powershell/7 \
        && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
        && chmod +x /opt/microsoft/powershell/7/pwsh \
        && ln -s /opt/microsoft/powershell/7/pwsh /usr/local/bin/pwsh

# Install az-cli
RUN pip install --upgrade pip
RUN pip install azure-cli

WORKDIR /azure-tools

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
ARG account=azureuser
RUN addgroup -S ${account} \
    && adduser -S ${account} -G ${account}
USER ${account}:${account}

CMD ["/bin/sh"]
