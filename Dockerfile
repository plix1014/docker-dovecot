#------------------------------------------------------------------------------------------
# build image
FROM debian:12-slim

ARG UIDGID=1000
ARG DEBIAN_FRONTEND=noninteractive

ENV CONT_VER=${CONT_VER:-0.5}
ENV container=docker
ENV LC_ALL=C
ENV TZ=${TZ:-Europe/Vienna}

LABEL org.opencontainers.image.description="Collects all your emails to your own server"
LABEL org.opencontainers.image.version="$TAG"
LABEL org.opencontainers.image.url="https://github.com/plix1014/docker-email-collector"
LABEL org.opencontainers.image.documentation="original URL https://github.com/optb/"
LABEL org.opencontainers.image.authors="plix1014@gmail.com"

# org.opencontainers.image.source 
# org.opencontainers.image.title

# install dovecot from debian repository
RUN apt-get -y update && apt-get -y install \
  tini \
  dovecot-core \
  dovecot-gssapi \
  dovecot-imapd \
  dovecot-ldap \
  dovecot-lmtpd \
  dovecot-auth-lua \
  dovecot-managesieved \
  dovecot-mysql \
  dovecot-pgsql \
  dovecot-pop3d \
  dovecot-sieve \
  dovecot-solr \
  dovecot-sqlite \
  dovecot-submissiond \
  netbase sudo procps \
  fetchmail \
  ca-certificates \
  ssl-cert \
  && apt-get -y --no-install-recommends install rspamd \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists /var/cache/apt \
  && echo "fetchmail ALL=(vmail) NOPASSWD:/usr/lib/dovecot/deliver" >> /etc/sudoers \
  && echo "fetchmail ALL=(vmail) NOPASSWD:/usr/bin/rspamc" >> /etc/sudoers \
  && groupadd -g ${UIDGID} vmail \
  && useradd -u ${UIDGID} -g ${UIDGID} vmail -d /srv/mail \
  && passwd -l vmail && \
  rm -rf /etc/dovecot && \
  mkdir /srv/mail && \
  chown vmail:vmail /srv/mail && \
  make-ssl-cert generate-default-snakeoil && \
  mkdir /etc/dovecot && \
  mkdir -p /var/log/rspamd && \
  ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/dovecot/cert.pem && \
  ln -s /etc/ssl/private/ssl-cert-snakeoil.key /etc/dovecot/key.pem


# add default config
ADD ./etc /etc/

# add scripts
ADD ./dec /dec/


RUN chmod 0550 /dec/docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/tini","--"]

CMD ["/dec/docker-entrypoint.sh","start"]

