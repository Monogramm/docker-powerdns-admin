
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

:construction: **This image is still in development!**

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

### SQLA_DB_TYPE

*Default value*: `postgresql`

This parameter contains the name of the driver used to access your PowerDNS Admin database.

Examples:
```
SQLA_DB_TYPE=mysql
SQLA_DB_TYPE=postgresql
SQLA_DB_TYPE=sqlite
```

### SQLA_DB_HOST

*Default value*: 

This parameter contains host name or ip address of PowerDNS Admin database server.

Examples:
```
SQLA_DB_HOST=localhost
SQLA_DB_HOST=127.0.2.1
SQLA_DB_HOST=192.168.0.10
SQLA_DB_HOST=mysql.myserver.com
```

### SQLA_DB_PORT

*Default value*: `5432`

This parameter contains the port of the PowerDNS Admin database.

Examples:
```
SQLA_DB_PORT=5432
SQLA_DB_PORT=3306
```

### SQLA_DB_NAME

*Default value*: `pdnsadmin`

This parameter contains name of PowerDNS Admin database.

Examples:
```
SQLA_DB_NAME=pdnsadmin
SQLA_DB_NAME=mydatabase
```

### SQLA_DB_USER

*Default value*: `pdnsadmin`

This parameter contains user name used to read and write into PowerDNS Admin database.

Examples:
```
SQLA_DB_USER=admin
SQLA_DB_USER=pdnsadminuser
```

### SQLA_DB_PASSWORD

*Default value*: 

This parameter contains password used to read and write into PowerDNS Admin database.

Examples:
```
SQLA_DB_PASSWORD=myadminpass
SQLA_DB_PASSWORD=myuserpassword
```

:construction: **TO BE COMPLETED**

### SECRET_KEY

### BIND_ADDRESS

### PORT

### PDNS_HOST

### PDNS_API_KEY


# Questions / Issues
If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-powerdns-admin) and write an issue.  
