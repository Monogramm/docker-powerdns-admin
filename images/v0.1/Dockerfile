FROM alpine

ARG BUILD_DEPENDENCIES="build-base \
    libffi-dev \
    libxml2-dev \
	libxslt-dev \
	mariadb-dev \
    mariadb-connector-c-dev \
    openldap-dev \
	openssl-dev \
	postgresql-dev \
    py3-pip \
    python3-dev \
    xmlsec-dev \
    yarn"

RUN set -ex; \
	apk update; \
	apk add --no-cache \
		curl \
		mariadb-connector-c \
		npm \
		openssl \
		postgresql-libs \
		py3-openssl \
		py3-gunicorn \
		py3-psycopg2 \
		python3 \
		unzip \
	; \
	apk add --no-cache ${BUILD_DEPENDENCIES}; \
	ln -s /usr/bin/pip3 /usr/bin/pip; \
	mkdir -p /usr/src/; \
	mkdir -p /var/www/powerdns-admin

WORKDIR /var/www/powerdns-admin
ENV FLASK_APP=app/__init__.py \
	BIND_ADDRESS=0.0.0.0 \
	PORT=9191

# Arguments to label built container
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION=v0.1

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

ADD https://github.com/ngoduykhanh/PowerDNS-Admin/archive/${VERSION}.zip /tmp/powerdns-admin.zip

RUN set -ex; \
	mkdir -p /tmp/powerdns-admin; \
	unzip /tmp/powerdns-admin.zip -d /tmp/powerdns-admin; \
	rm /tmp/powerdns-admin.zip; \
	mkdir -p /usr/src/powerdns-admin; \
	cp -r /tmp/powerdns-admin/PowerDNS-Admin-*/* /usr/src/powerdns-admin; \
	rm -rf /tmp/powerdns-admin; \
	cp -r /usr/src/powerdns-admin/* .; \
	rm -rf \
		./configs/ \
		./docker/ \
		./tests/ \
		./.env \
		./.travis.yml \
		./config_template.py \
		./docker-compose*.yml \
		./env-test \
	; \
	pip3 install --upgrade pip; \
	pip3 install -r ./requirements.txt; \
	pip3 install pip-autoremove; \
    pip3-autoremove cssmin -y; \
    pip3-autoremove jsmin -y; \
    pip3-autoremove pytest -y; \
    pip3 uninstall -y pip-autoremove; \
    apk del ${BUILD_DEPENDENCIES}; \
	rm -rf /var/cache/apk/*; \
    addgroup -S pda;  \
    adduser -S -D -G pda pda; \
	chown -R pda:pda /var/www/powerdns-admin

COPY config_template.py generate_salt.py init_admin.py init_setting.py ./
COPY entrypoint.sh /entrypoint.sh

RUN set -ex; \
	chmod 755 \
		/entrypoint.sh\
		generate_salt.py \
		init_admin.py \
		init_setting.py

VOLUME [ "/var/www/powerdns-admin/upload", "/var/www/powerdns-admin/logs", "/var/www/powerdns-admin/migrations", "/var/www/powerdns-admin/db" ]
HEALTHCHECK CMD ["wget","--output-document=-","--quiet","--tries=1","http://127.0.0.1:${PORT}/"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["gunicorn","powerdnsadmin:create_app()"]
