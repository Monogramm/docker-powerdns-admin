#!/usr/bin/env python3

import os
import logging

from powerdnsadmin import create_app
from powerdnsadmin.models.user import User

app = create_app()
app.logger.setLevel(logging.INFO)


with app.app_context():
    # Admin user
    ADMIN_USERNAME = os.environ.get('ADMIN_USERNAME')
    ADMIN_PASSWORD = os.environ.get('ADMIN_PASSWORD')
    ADMIN_FIRSTNAME = os.environ.get('ADMIN_FIRSTNAME')
    ADMIN_LASTNAME = os.environ.get('ADMIN_LASTNAME')
    ADMIN_EMAIL = os.environ.get('ADMIN_EMAIL')
    admin_user = User(username=ADMIN_USERNAME,
        plain_text_password=ADMIN_PASSWORD,
        firstname=ADMIN_FIRSTNAME,
        lastname=ADMIN_LASTNAME,
        email=ADMIN_EMAIL)

    result = admin_user.create_local_user()
    if result and result['status']:
        print('Admin user created: ' + ADMIN_USERNAME)
    else:
        print('Could not create admin user: ' + result['msg'])
