#!/usr/bin/env python3

import os
import logging

from powerdnsadmin import create_app
from powerdnsadmin.models.setting import Setting

app = create_app()
app.logger.setLevel(logging.INFO)


with app.app_context():
    # PDNS Admin settings
    legal_envvars_setting = (
        'MAINTENANCE',
        'FULLSCREEN_LAYOUT',
        'RECORD_HELPER',
        'LOGIN_LDAP_FIRST',
        'DEFAULT_RECORD_TABLE_SIZE',
        'DEFAULT_DOMAIN_TABLE_SIZE',
        'AUTO_PTR',
        'RECORD_QUICK_EDIT',
        'PRETTY_IPV6_PTR',
        'DNSSEC_ADMINS_ONLY',
        'ALLOW_USER_CREATE_DOMAIN',
        'BG_DOMAIN_UPDATES',
        'SITE_NAME',
        'SESSION_TIMEOUT',
        'PDNS_API_URL',
        'PDNS_API_KEY',
        'PDNS_VERSION',
        'LOCAL_DB_ENABLED',
        'SIGNUP_ENABLED',
        'LDAP_ENABLED',
        'LDAP_TYPE',
        'LDAP_URI',
        'LDAP_BASE_DN',
        'LDAP_ADMIN_USERNAME',
        'LDAP_ADMIN_PASSWORD',
        'LDAP_FILTER_BASIC',
        'LDAP_FILTER_USERNAME',
        'LDAP_SG_ENABLED',
        'LDAP_ADMIN_GROUP',
        'LDAP_OPERATOR_GROUP',
        'LDAP_USER_GROUP',
        'LDAP_DOMAIN',
        'GITHUB_OAUTH_ENABLED',
        'GITHUB_OAUTH_KEY',
        'GITHUB_OAUTH_SECRET',
        'GITHUB_OAUTH_SCOPE',
        'GITHUB_OAUTH_API_URL',
        'GITHUB_OAUTH_TOKEN_URL',
        'GITHUB_OAUTH_AUTHORIZE_URL',
        'GOOGLE_OAUTH_ENABLED',
        'GOOGLE_OAUTH_CLIENT_ID',
        'GOOGLE_OAUTH_CLIENT_SECRET',
        'GOOGLE_TOKEN_URL',
        'GOOGLE_OAUTH_SCOPE',
        'GOOGLE_AUTHORIZE_URL',
        'GOOGLE_BASE_URL',
        'OIDC_OAUTH_ENABLED',
        'OIDC_OAUTH_KEY',
        'OIDC_OAUTH_SECRET',
        'OIDC_OAUTH_SCOPE',
        'OIDC_OAUTH_API_URL',
        'OIDC_OAUTH_TOKEN_URL',
        'OIDC_OAUTH_AUTHORIZE_URL',
        'FORWARD_RECORDS_ALLOW_EDIT',
        'REVERSE_RECORDS_ALLOW_EDIT',
        'TTL_OPTIONS'
    )


    # add every setting from environment variables
    import os
    import sys
    for v in legal_envvars_setting:
        if v in os.environ:
            name = v.lower()
            value = os.environ[v]
            Setting().set(name, value)
            print('Defined Setting: ' + name)
