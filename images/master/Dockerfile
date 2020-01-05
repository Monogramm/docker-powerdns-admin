FROM alpine

RUN set -ex; \
	apk update; \
	apk add --no-cache \
		build-base \
		curl \
		libffi-dev \
		libxslt-dev \
		mariadb-dev \
		npm \
		openldap-dev \
		openssl \
		openssl-dev \
		postgresql-dev \
		postgresql-libs \
		py3-openssl \
		python3 \
		python3-dev \
		unzip \
		xmlsec-dev \
		yarn \
	; \
	mkdir -p /usr/src/; \
	mkdir -p /var/www/powerdns-admin; \
	rm -rf /var/cache/apk/*

WORKDIR /var/www/powerdns-admin
ENV FLASK_APP=app/__init__.py \
	BIND_ADDRESS=0.0.0.0 \
	PORT=9191

# Arguments to label built container
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION=master

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
	pip3 install psycopg2; \
	pip3 install -r ./requirements.txt

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
