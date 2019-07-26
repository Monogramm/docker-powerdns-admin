
[uri_license]: http://www.gnu.org/licenses/agpl.html
[uri_license_image]: https://img.shields.io/badge/License-AGPL%20v3-blue.svg

[![License: AGPL v3][uri_license_image]][uri_license]
[![Build Status](https://travis-ci.org/Monogramm/docker-powerdns-admin.svg)](https://travis-ci.org/Monogramm/docker-powerdns-admin)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/monogramm/docker-powerdns-admin.svg)](https://hub.docker.com/r/monogramm/docker-powerdns-admin/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-powerdns-admin.svg)](https://hub.docker.com/r/monogramm/docker-powerdns-admin/)
[![Docker layers](https://images.microbadger.com/badges/image/monogramm/docker-powerdns-admin.svg)](https://microbadger.com/images/monogramm/docker-powerdns-admin)

# PowerDNS Admin on Docker

Docker image for PowerDNS Admin.

Provides full database configuration, salt generation, configuration management, and so on...

:construction: **This image is still in beta and should not be used in production (yet)!**

## What is PowerDNS Admin ?

PowerDNS Admin is a PowerDNS web interface with monitoring and administration features.

> [More informations](https://github.com/ngoduykhanh/PowerDNS-Admin)

## Supported tags

https://hub.docker.com/r/monogramm/docker-powerdns-admin/

* `master`

## How to run this image ?

This image is based on the [officiel alpine repository](https://registry.hub.docker.com/_/alpine/).
It is inspired from [PowerDNS-Admin](https://github.com/ngoduykhanh/PowerDNS-Admin) and [ixpict/powerdns-admin-pgsql](https://github.com/ixpict/powerdns-admin-pgsql).

This image does not contain the database for PowerDNS Admin. You need to use either an existing database or a database container.

## Auto configuration via environment variables

The PowerDNS Admin image supports auto configuration via environment variables.

### Database configuration

Examples:
* Postgresql (default)
    ```
    PDA_DB_USER=pdnsadmin
    PDA_DB_PASSWORD=
    PDA_DB_TYPE=postgresql
    PDA_DB_HOST=postgresql
    PDA_DB_PORT=5432
    PDA_DB_NAME=pdnsadmin
    SQLALCHEMY_TRACK_MODIFICATIONS=True
    ```
* MySQL / MariaDB
    ```
    PDA_DB_USER=pdnsadmin
    PDA_DB_PASSWORD=somethingverysecure
    PDA_DB_TYPE=mysql
    PDA_DB_HOST=mysql
    PDA_DB_PORT=5432
    PDA_DB_NAME=pdnsadmin
    SQLALCHEMY_TRACK_MODIFICATIONS=True
    ```
* SQLite
    ```
    PDA_DB_USER=pdnsadmin
    PDA_DB_PASSWORD=somethingverysecure
    PDA_DB_TYPE=sqlite
    PDA_DB_NAME=pdnsadmin
    SQLALCHEMY_TRACK_MODIFICATIONS=True
    ```

### Gunicorn configuration

Examples:
* Default
    ```
	GUNICORN_TIMEOUT=120
	GUNICORN_WORKERS=4
	GUNICORN_LOGLEVEL=info
	BIND_ADDRESS=0.0.0.0
	PORT=9191
    ```
* SSL (you need to provide certificates yourself)
    ```
	GUNICORN_TIMEOUT=120
	GUNICORN_WORKERS=4
	GUNICORN_LOGLEVEL=warn
    GUNICORN_CERTFILE=/etc/letsencrypt/live/my.domain.com/fullchain.pem
    GUNICORN_KEYFILE=/etc/letsencrypt/live/my.domain.com/privkey.pem
	BIND_ADDRESS=0.0.0.0
	PORT=443
    ```

### PowerDNS configuration

Example:
* Default
    ```
    PDNS_PROTO=http
    PDNS_PORT=8081
    ```
* SSL
    ```
    PDNS_PROTO=https
    PDNS_PORT=8081
    ```

### PowerDNS Admin configuration

Example:
    ```
    SECRET_KEY=somethingreallysecureornothingtogeneraterandomsecret
    TIMEOUT=5
    LOG_LEVEL=WARN
    LOG_FILE=pdnsadmin.log
    SALT=somethingsecureornothingtogeneraterandomsalt
    ```

`SECRET_KEY` and `SALT` will be randomly generated on startup and kept in config if left empty.

### PowerDNS Admin SAML Authentication

Disabled by default, SAML can be configured with the following properties:
    ```
    SAML_ENABLED
    SAML_DEBUG
    SAML_PATH
    SAML_METADATA_URL
    SAML_METADATA_CACHE_LIFETIME
    SAML_IDP_SSO_BINDING
    SAML_IDP_ENTITY_ID
    SAML_NAMEID_FORMAT
    SAML_ATTRIBUTE_EMAIL
    SAML_ATTRIBUTE_GIVENNAME
    SAML_ATTRIBUTE_SURNAME
    SAML_ATTRIBUTE_NAME
    SAML_ATTRIBUTE_USERNAME
    SAML_ATTRIBUTE_ADMIN
    SAML_ATTRIBUTE_GROUP
    SAML_GROUP_ADMIN_NAME
    SAML_GROUP_TO_ACCOUNT_MAPPING
    SAML_ATTRIBUTE_ACCOUNT
    SAML_SP_ENTITY_ID
    SAML_SP_CONTACT_NAME
    SAML_SP_CONTACT_MAIL
    SAML_SIGN_REQUEST
    SAML_WANT_MESSAGE_SIGNED
    SAML_LOGOUT
    SAML_LOGOUT_URL
    ```

See `docker-config_template.py` for details.

### PowerDNS Admin user

Disabled by default, you can enable creation of a default admin user by setting `ADMIN_PASSWORD`. The user will only be created for a new instance of PowerDNS Admin!

Example configuration:
    ```
    ADMIN_USERNAME=admin
    ADMIN_PASSWORD=somethingverysecure
    ADMIN_FIRSTNAME=PowerDNS
    ADMIN_LASTNAME=Admin
    ADMIN_EMAIL=admin@my.domain.com
    ```

### PowerDNS Admin settings

The container can initialize its settings through environment variables. The settings will only be created for a new instance of PowerDNS Admin!

Settings available:
    ```
    MAINTENANCE
    FULLSCREEN_LAYOUT
    RECORD_HELPER
    LOGIN_LDAP_FIRST
    DEFAULT_RECORD_TABLE_SIZE
    DEFAULT_DOMAIN_TABLE_SIZE
    AUTO_PTR
    RECORD_QUICK_EDIT
    PRETTY_IPV6_PTR
    DNSSEC_ADMINS_ONLY
    ALLOW_USER_CREATE_DOMAIN
    BG_DOMAIN_UPDATES
    SITE_NAME
    SESSION_TIMEOUT
    PDNS_API_URL
    PDNS_API_KEY
    PDNS_VERSION
    LOCAL_DB_ENABLED
    SIGNUP_ENABLED
    LDAP_ENABLED
    LDAP_TYPE
    LDAP_URI
    LDAP_BASE_DN
    LDAP_ADMIN_USERNAME
    LDAP_ADMIN_PASSWORD
    LDAP_FILTER_BASIC
    LDAP_FILTER_USERNAME
    LDAP_SG_ENABLED
    LDAP_ADMIN_GROUP
    LDAP_OPERATOR_GROUP
    LDAP_USER_GROUP
    LDAP_DOMAIN
    GITHUB_OAUTH_ENABLED
    GITHUB_OAUTH_KEY
    GITHUB_OAUTH_SECRET
    GITHUB_OAUTH_SCOPE
    GITHUB_OAUTH_API_URL
    GITHUB_OAUTH_TOKEN_URL
    GITHUB_OAUTH_AUTHORIZE_URL
    GOOGLE_OAUTH_ENABLED
    GOOGLE_OAUTH_CLIENT_ID
    GOOGLE_OAUTH_CLIENT_SECRET
    GOOGLE_TOKEN_URL
    GOOGLE_OAUTH_SCOPE
    GOOGLE_AUTHORIZE_URL
    GOOGLE_BASE_URL
    OIDC_OAUTH_ENABLED
    OIDC_OAUTH_KEY
    OIDC_OAUTH_SECRET
    OIDC_OAUTH_SCOPE
    OIDC_OAUTH_API_URL
    OIDC_OAUTH_TOKEN_URL
    OIDC_OAUTH_AUTHORIZE_URL
    FORWARD_RECORDS_ALLOW_EDIT
    REVERSE_RECORDS_ALLOW_EDIT
    TTL_OPTION
    ```

# Questions / Issues
If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-powerdns-admin) and write an issue.  
