#!/usr/bin/env sh
set -e

WORK_DIR=/var/www/powerdns-admin/

export FLASK_APP=app/__init__.py

# == Vars
#
DB_MIGRATION_DIR='/var/www/powerdns-admin/migrations'
if [[ -z ${PDNS_PROTO} ]];
 then PDNS_PROTO="http"
fi

if [[ -z ${PDNS_PORT} ]];
 then PDNS_PORT=8081
fi


# Wait for us to be able to connect to before proceeding
if [ "${SQLA_DB_TYPE}" != "sqlite" ]; then
  echo "===> Waiting for $PDA_DB_HOST Database service"
  until nc -zv \
    $PDA_DB_HOST \
    $PDA_DB_PORT;
  do
    echo "Database ($PDA_DB_HOST) is unavailable - sleeping"
    sleep 1
  done
fi


echo "===> Configuration management"

if [ ! -f config.py ]; then
  echo "---> Creating default configuration"
  cp config_template.py config.py

  ## TODO Generate random secret if not set in config
  #if grep 'We are the world' $WORK_DIR/config.py; then
  #  echo "---> Generating random secret"
  #  SECRET_KEY=$(openssl rand -hex 64)
  #  sed -i "s|'SECRET_KEY', 'We are the world'|'SECRET_KEY', '${SECRET_KEY}'|g" $WORK_DIR/config.py
  #fi
  ## TODO Generate random salt if default present
  #if grep '$2b$12$yLUMTIfl21FKJQpTkRQXCu' $WORK_DIR/config.py; then
  #  echo "---> Generating random salt"
  #  SALT=$(python generate_salt.py)
  #  sed -i "s|SALT = '.*'|SALT = '${SALT}'|g" $WORK_DIR/config.py
  #fi

fi


echo "===> Database management"
if [ ! -f "${DB_MIGRATION_DIR}/README" ]; then
  echo "---> Running DB Init"
  flask db init --directory ${DB_MIGRATION_DIR}
  echo "---> Running DB Migration"
  set +e
  flask db migrate -m "Init DB" --directory ${DB_MIGRATION_DIR}
  flask db upgrade --directory ${DB_MIGRATION_DIR}
  set -e
  echo "---> Running data init"
  ./init_data.py

else
  echo "---> Running DB Migration"
  set +e
  flask db migrate -m "Upgrade DB Schema" --directory ${DB_MIGRATION_DIR}
  flask db upgrade --directory ${DB_MIGRATION_DIR}
  set -e
fi

#echo "===> (TODO) Update PDNS API connection info"


echo "===> Assets management"
echo "---> Running Yarn"
yarn install --pure-lockfile

echo "---> Running Flask assets"
flask assets build

echo "Start gunicorn server"
exec "$@"
