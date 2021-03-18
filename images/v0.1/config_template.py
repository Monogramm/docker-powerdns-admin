import os
basedir = os.path.abspath(os.path.dirname(__file__))


# BASIC APP CONFIG
SECRET_KEY = os.environ.get('SECRET_KEY', 'We are the world')
BIND_ADDRESS = os.environ.get('BIND_ADDRESS', '0.0.0.0')
PORT = int(os.environ.get('PORT', 9191))

# TIMEOUT - for large zones
TIMEOUT = int(os.environ.get('TIMEOUT', 10))

# LOG CONFIG
logdir = os.path.join(basedir, 'logs')
LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO')
LOG_FILE = os.path.join(logdir, os.environ.get('LOG_FILE', 'logfile.log'))

SALT = os.environ.get('SALT', '$2b$12$yLUMTIfl21FKJQpTkRQXCu')

# UPLOAD DIRECTORY
UPLOAD_DIR = os.path.join(basedir, 'upload')

# DATABASE CONFIG
SQLA_DB_USER = os.environ.get('PDA_DB_USER', 'pdnsadmin')
SQLA_DB_PASSWORD = os.environ.get('PDA_DB_PASSWORD')
SQLA_DB_TYPE = os.environ.get('PDA_DB_TYPE', 'postgresql')
SQLA_DB_HOST = os.environ.get('PDA_DB_HOST', 'postgresql')
SQLA_DB_PORT = os.environ.get('PDA_DB_PORT', 5432 )
SQLA_DB_NAME = os.environ.get('PDA_DB_NAME', 'pdnsadmin')

dbdir = os.path.join(basedir, 'db')

SQLALCHEMY_TRACK_MODIFICATIONS = os.getenv('SQLALCHEMY_TRACK_MODIFICATIONS', 'True').lower() == 'true'

# DATABASE
if SQLA_DB_TYPE == 'sqlite':
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(dbdir, SQLA_DB_NAME+'.db')
else:
    SQLALCHEMY_DATABASE_URI = SQLA_DB_TYPE+'://'+SQLA_DB_USER+':'+SQLA_DB_PASSWORD+'@'+SQLA_DB_HOST+':'+str(SQLA_DB_PORT)+'/'+SQLA_DB_NAME

# SAML Authentication
SAML_ENABLED = os.getenv('SAML_ENABLED', 'False').lower() == 'true'
SAML_DEBUG = os.getenv('SAML_DEBUG', 'False').lower() == 'true'
SAML_PATH = os.path.join(os.path.dirname(__file__), 'saml')

##Example for ADFS Metadata-URL
##SAML_METADATA_URL = 'https://<hostname>/FederationMetadata/2007-06/FederationMetadata.xml'
SAML_METADATA_URL = os.environ.get('SAML_METADATA_URL')

#Cache Lifetime in Seconds
SAML_METADATA_CACHE_LIFETIME = int(os.environ.get('SAML_METADATA_CACHE_LIFETIME', 1))

# SAML SSO binding format to use
## Default: library default (urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect)
#SAML_IDP_SSO_BINDING = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'
SAML_IDP_SSO_BINDING = os.environ.get('SAML_IDP_SSO_BINDING')

## EntityID of the IdP to use. Only needed if more than one IdP is
##   in the SAML_METADATA_URL
### Default: First (only) IdP in the SAML_METADATA_URL
### Example: https://idp.example.edu/idp
#SAML_IDP_ENTITY_ID = 'https://idp.example.edu/idp'
SAML_IDP_ENTITY_ID = os.environ.get('SAML_IDP_ENTITY_ID')

## NameID format to request
### Default: The SAML NameID Format in the metadata if present,
###   otherwise urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified
### Example: urn:oid:0.9.2342.19200300.100.1.1
#SAML_NAMEID_FORMAT = 'urn:oid:0.9.2342.19200300.100.1.1'
SAML_NAMEID_FORMAT = os.environ.get('SAML_NAMEID_FORMAT')

## Attribute to use for Email address
### Default: email
### Example: urn:oid:0.9.2342.19200300.100.1.3
#SAML_ATTRIBUTE_EMAIL = 'urn:oid:0.9.2342.19200300.100.1.3'
SAML_ATTRIBUTE_EMAIL = os.environ.get('SAML_ATTRIBUTE_EMAIL')

## Attribute to use for Given name
### Default: givenname
### Example: urn:oid:2.5.4.42
#SAML_ATTRIBUTE_GIVENNAME = 'urn:oid:2.5.4.42'
SAML_ATTRIBUTE_GIVENNAME = os.environ.get('SAML_ATTRIBUTE_GIVENNAME')

## Attribute to use for Surname
### Default: surname
### Example: urn:oid:2.5.4.4
#SAML_ATTRIBUTE_SURNAME = 'urn:oid:2.5.4.4'
SAML_ATTRIBUTE_SURNAME = os.environ.get('SAML_ATTRIBUTE_SURNAME')

## Split into Given name and Surname
## Useful if your IDP only gives a display name
### Default: none
### Example: http://schemas.microsoft.com/identity/claims/displayname
#SAML_ATTRIBUTE_NAME = 'http://schemas.microsoft.com/identity/claims/displayname'
SAML_ATTRIBUTE_NAME = os.environ.get('SAML_ATTRIBUTE_NAME')

## Attribute to use for username
### Default: Use NameID instead
### Example: urn:oid:0.9.2342.19200300.100.1.1
#SAML_ATTRIBUTE_USERNAME = 'urn:oid:0.9.2342.19200300.100.1.1'
SAML_ATTRIBUTE_USERNAME = os.environ.get('SAML_ATTRIBUTE_USERNAME')

## Attribute to get admin status from
### Default: Don't control admin with SAML attribute
### Example: https://example.edu/pdns-admin
### If set, look for the value 'true' to set a user as an administrator
### If not included in assertion, or set to something other than 'true',
###  the user is set as a non-administrator user.
#SAML_ATTRIBUTE_ADMIN = 'https://example.edu/pdns-admin'
SAML_ATTRIBUTE_ADMIN = os.environ.get('SAML_ATTRIBUTE_ADMIN')

## Attribute to get group from
### Default: Don't use groups from SAML attribute
### Example: https://example.edu/pdns-admin-group
#SAML_ATTRIBUTE_GROUP = 'https://example.edu/pdns-admin'
SAML_ATTRIBUTE_GROUP = os.environ.get('SAML_ATTRIBUTE_GROUP')

## Group name to get admin status from
### Default: Don't control admin with SAML group
### Example: https://example.edu/pdns-admin
#SAML_GROUP_ADMIN_NAME = 'powerdns-admin'
SAML_GROUP_ADMIN_NAME = os.environ.get('SAML_GROUP_ADMIN_NAME')

## Attribute to get group to account mappings from
### Default: None
### If set, the user will be added and removed from accounts to match
###  what's in the login assertion if they are in the required group
#SAML_GROUP_TO_ACCOUNT_MAPPING = 'dev-admins=dev,prod-admins=prod'
SAML_GROUP_TO_ACCOUNT_MAPPING = os.environ.get('SAML_GROUP_TO_ACCOUNT_MAPPING')

## Attribute to get account names from
### Default: Don't control accounts with SAML attribute
### If set, the user will be added and removed from accounts to match
###  what's in the login assertion. Accounts that don't exist will
###  be created and the user added to them.
#SAML_ATTRIBUTE_ACCOUNT = 'https://example.edu/pdns-account'
SAML_ATTRIBUTE_ACCOUNT = os.environ.get('SAML_ATTRIBUTE_ACCOUNT')

#SAML_SP_ENTITY_ID = 'http://<SAML SP Entity ID>'
SAML_SP_ENTITY_ID = os.environ.get('SAML_SP_ENTITY_ID')

#SAML_SP_CONTACT_NAME = '<contact name>'
SAML_SP_CONTACT_NAME = os.environ.get('SAML_SP_CONTACT_NAME')

#SAML_SP_CONTACT_MAIL = '<contact mail>'
SAML_SP_CONTACT_MAIL = os.environ.get('SAML_SP_CONTACT_MAIL')

#Configures if SAML tokens should be encrypted.
#If enabled a new app certificate will be generated on restart
SAML_SIGN_REQUEST = os.getenv('SAML_SIGN_REQUEST', 'False').lower() == 'true'

# Configures if you want to request the IDP to sign the message
# Default is True
SAML_WANT_MESSAGE_SIGNED = os.getenv('SAML_WANT_MESSAGE_SIGNED', 'True').lower() == 'true'

#Use SAML standard logout mechanism retrieved from idp metadata
#If configured false don't care about SAML session on logout.
#Logout from PowerDNS-Admin only and keep SAML session authenticated.
SAML_LOGOUT = os.getenv('SAML_LOGOUT', 'False').lower() == 'true'
#Configure to redirect to a different url then PowerDNS-Admin login after SAML logout
#for example redirect to google.com after successful saml logout
#SAML_LOGOUT_URL = 'https://google.com'
SAML_LOGOUT_URL = os.environ.get('SAML_LOGOUT_URL')
