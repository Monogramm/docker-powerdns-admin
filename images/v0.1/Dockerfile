FROM alpine

ARG PDNSADMIN_VERSION=v0.1

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

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

ADD https://github.com/ngoduykhanh/PowerDNS-Admin/archive/${PDNSADMIN_VERSION}.zip /tmp/powerdns-admin.zip

RUN set -ex; \
	mkdir -p /tmp/powerdns-admin; \
	unzip /tmp/powerdns-admin.zip -d /tmp/powerdns-admin; \
	rm /tmp/powerdns-admin.zip; \
	mkdir -p /usr/src/powerdns-admin; \
	cp -r /tmp/powerdns-admin/PowerDNS-Admin-*/* /usr/src/powerdns-admin; \
	rm -rf /tmp/powerdns-admin; \
	cp -r /usr/src/powerdns-admin/* /var/www/powerdns-admin/; \
	rm -rf \
		/var/www/powerdns-admin/config/ \
		/var/www/powerdns-admin/docker/ \
		/var/www/powerdns-admin/migrations/ \
		/var/www/powerdns-admin/tests/ \
		/var/www/powerdns-admin/.env \
		/var/www/powerdns-admin/.travis.yml \
		/var/www/powerdns-admin/config_template.py \
		/var/www/powerdns-admin/docker-compose*.yml \
		/var/www/powerdns-admin/env-test \
		/var/www/powerdns-admin/run_travis.sh \
	; \
	pip3 install --upgrade pip; \
	pip3 install psycopg2; \
	pip3 install -r /var/www/powerdns-admin/requirements.txt

COPY config_template.py generate_salt.py /var/www/powerdns-admin/
COPY entrypoint.sh /entrypoint.sh

RUN set -ex; \
	chmod 755 /entrypoint.sh

EXPOSE 9191

ENV FLASK_APP=app/__init__.py \
	GUNICORN_TIMEOUT=120 \
	GUNICORN_WORKERS=4 \
	GUNICORN_LOGLEVEL=info \
	BIND_ADDRESS=0.0.0.0 \
	PORT=9191 \
	SECRET_KEY= \
	TIMEOUT=10 \
	LOG_LEVEL=INFO \
	LOG_FILE= \
	SALT= \
	PDA_DB_USER=pdnsadmin \
	PDA_DB_PASSWORD= \
	PDA_DB_TYPE=postgresql \
	PDA_DB_HOST= \
	PDA_DB_PORT=5432 \
	PDA_DB_NAME=pdnsadmin \
	SQLALCHEMY_TRACK_MODIFICATIONS=True \
	SAML_ENABLED=False \
	SAML_DEBUG=False \
	SAML_METADATA_URL= \
	SAML_METADATA_CACHE_LIFETIME=1 \
	SAML_IDP_SSO_BINDING= \
	SAML_IDP_ENTITY_ID= \
	SAML_NAMEID_FORMAT= \
	SAML_ATTRIBUTE_EMAIL=email \
	SAML_ATTRIBUTE_GIVENNAME=givenname \
	SAML_ATTRIBUTE_SURNAME=surname \
	SAML_ATTRIBUTE_NAME= \
	SAML_ATTRIBUTE_USERNAME= \
	SAML_ATTRIBUTE_ADMIN= \
	SAML_ATTRIBUTE_GROUP= \
	SAML_GROUP_ADMIN_NAME= \
	SAML_GROUP_TO_ACCOUNT_MAPPING= \
	SAML_ATTRIBUTE_ACCOUNT= \
	SAML_SP_ENTITY_ID= \
	SAML_SP_CONTACT_NAME= \
	SAML_SP_CONTACT_MAIL= \
	SAML_SIGN_REQUEST=False \
	SAML_WANT_MESSAGE_SIGNED=True \
	SAML_LOGOUT=False \
	SAML_LOGOUT_URL=

ENTRYPOINT ["/entrypoint.sh"]
CMD ["gunicorn","app:app"]
