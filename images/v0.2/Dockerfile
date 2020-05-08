FROM ngoduykhanh/powerdns-admin:0.2.2

ENV BIND_ADDRESS=0.0.0.0 \
  PORT=9191

COPY --chown=pda:pda config_template.py ./configs/
COPY --chown=pda:pda generate_salt.py init_admin.py init_setting.py ./
COPY entrypoint.sh /entrypoint.sh

RUN set -ex; \
  apk update; \
  apk add --no-cache \
    openldap-dev \
    openssl \
    py3-openssl \
    sqlite \
  ; \
  chmod 755 \
    /entrypoint.sh\
    ./generate_salt.py \
    ./init_admin.py \
    ./init_setting.py \
  ;

VOLUME [ "/app/upload", "/app/logs", "/app/migrations", "/app/db" ]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["gunicorn","powerdnsadmin:create_app()","--user","pda","--group","pda"]

# Arguments to label built container
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION=v0.2.2

# Container labels (http://label-schema.org/)
# Container annotations (https://github.com/opencontainers/image-spec)
LABEL maintainer="Monogramm maintainers <opensource at monogramm dot io>" \
      product="PowerDNS-Admin" \
      version=$VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Monogramm/docker-powerdns-admin" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="PowerDNS-Admin" \
      org.label-schema.description="A PowerDNS web interface with advanced features" \
      org.label-schema.url="https://github.com/ngoduykhanh/PowerDNS-Admin" \
      org.label-schema.vendor="Khanh Ngo" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/Monogramm/docker-powerdns-admin" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.title="PowerDNS-Admin" \
      org.opencontainers.image.description="A PowerDNS web interface with advanced features" \
      org.opencontainers.image.url="https://github.com/ngoduykhanh/PowerDNS-Admin" \
      org.opencontainers.image.vendor="Khanh Ngo" \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.authors="Monogramm maintainers <opensource at monogramm dot io>"
