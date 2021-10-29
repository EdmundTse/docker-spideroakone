FROM ghcr.io/linuxserver/baseimage-rdesktop-web:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SPIDEROAKONE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer=""

ENV \
  GUIAUTOSTART="true" \
  HOME="/config"

RUN \
  echo "**** install SpiderOakONE ****" && \
  if [ -z ${SPIDEROAKONE_RELEASE+x} ]; then \
    SPIDEROAKONE_URL="https://spideroak.com/release/spideroak/slack_tar_x64"; \
    SPIDEROAKONE_RELEASE=$(curl -sIX GET "https://spideroak.com/release/spideroak/slack_tar_x64" \
    | grep -o -E "filename=.*$" | sed -e 's/filename=SpiderOakONE-//' | sed -e "s/-slack_tar_x64.tgz//"); \
  else \
    SPIDEROAKONE_URL="https://spideroak.com/share/M5XWYZDFNY/retriever/c%3A/Fetch/SpiderOak%20One/${SPIDEROAKONE_RELEASE}/SpiderOakONE-${SPIDEROAKONE_RELEASE}-slack_tar_x64.tgz"; \
  fi && \
  curl "$SPIDEROAKONE_URL" | tar -xzf - && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 3000
VOLUME /config
