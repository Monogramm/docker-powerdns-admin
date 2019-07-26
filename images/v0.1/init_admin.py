#!/usr/bin/env python3

import os

from app import db
from app.models import User


# Admin user
if os.environ.get('ADMIN_PASSWORD'):
    ADMIN_USERNAME = os.environ.get('ADMIN_USERNAME')
    ADMIN_PASSWORD = os.environ.get('ADMIN_PASSWORD')
    ADMIN_FIRSTNAME = os.environ.get('ADMIN_FIRSTNAME')
    ADMIN_LASTNAME = os.environ.get('ADMIN_LASTNAME')
    ADMIN_EMAIL = os.environ.get('ADMIN_EMAIL')
    admin_user = User(username=ADMIN_USERNAME, 
        plain_text_password=ADMIN_PASSWORD,
        firstname=ADMIN_FIRSTNAME,
        lastname=ADMIN_LASTNAME,
        role_id=1,
        email=ADMIN_EMAIL)
    db.session.add(admin_user)


db.session.commit()
