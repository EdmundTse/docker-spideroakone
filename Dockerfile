#
# SpiderOak One Dockerfile
#

# Pull base image.
FROM jlesage/baseimage-gui:debian-10-v3.5.7

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=unknown

# Define software download URLs.
ARG SPIDEROAKONE_URL=https://spideroak.com/release/spideroak/slack_tar_x64

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN add-pkg \
        xterm

# Install SpiderOak One.
RUN \
    add-pkg --virtual build-dependencies \
        cpio curl && \
    # Download and install.
    curl ${SPIDEROAKONE_URL} | gzip -d -c - | cpio -id --no-preserve-owner --directory=/ && \
    # Cleanup.
    del-pkg build-dependencies && \
    rm -rf /tmp/* /tmp/.[!.]*

# Maximize only the main/initial window.
RUN \
    sed-patch 's/<application type="normal">/<application type="normal" title="SpiderOakONE">/' \
        /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://icons.iconarchive.com/icons/papirus-team/papirus-apps/128/SpiderOakONE-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /

# Set environment variables.
ENV APP_NAME="SpiderOak ONE" \
    HOME=/config

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]

# Metadata.
LABEL \
      org.label-schema.name="spideroakone" \
      org.label-schema.description="Docker container for SpiderOak ONE" \
      org.label-schema.version="$DOCKER_IMAGE_VERSION" \
      org.label-schema.vcs-url="https://github.com/EdmundTse/docker-spideroakone" \
      org.label-schema.schema-version="1.0"
