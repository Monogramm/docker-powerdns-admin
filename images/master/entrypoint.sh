#!/usr/bin/env sh
set -e

# == Functions
#
log() {
  echo "[$(date +%Y-%m-%dT%H:%M:%S%:z)] $@"
}

# == Vars
#
if [ ! -d ./db/migrations ] || [ ./migrations -nt ./db/migrations ]; then
  log "===> Preparing Database migrations"
  cp -rf ./migrations ./db/
fi
DB_MIGRATION_DIR=./db/migrations

if [[ -z ${PDNS_PROTO} ]]; then
  PDNS_PROTO="http"
fi

if [[ -z ${PDNS_PORT} ]]; then
  PDNS_PORT=8081
fi


# Wait for us to be able to connect to DB before proceeding
if [ "${PDA_DB_TYPE}" != "sqlite" ]; then
  log "===> Waiting for $PDA_DB_HOST Database service"
  until nc -zv \
    $PDA_DB_HOST \
    $PDA_DB_PORT;
  do
    log "Database ($PDA_DB_HOST) is unavailable - sleeping"
    sleep 1
  done
elif [ ! -f "./db/$PDA_DB_NAME.sqlite3" ]; then
  log "===> Initializing SQLite Database"
  mkdir -p ./db
  touch "./db/$PDA_DB_NAME.sqlite3"
fi


log "===> Configuration management"

if [ ! -f config.py ]; then
  log "---> Creating default configuration"
  cp config_template.py config.py

  # Generate random secret if default present
  if grep -q 'We are the world' ./config.py; then
    log "---> Generating random secret"
    SECRET_KEY=$(openssl rand -hex 64)
    sed -i "s|'SECRET_KEY', 'We are the world'|'SECRET_KEY', '${SECRET_KEY}'|g" ./config.py
  fi

  # Generate random salt if default present
  if grep -q '$2b$12$yLUMTIfl21FKJQpTkRQXCu' ./config.py; then
    log "---> Generating random salt"
    SALT=$(python3 generate_salt.py)
    sed -i "s|'SALT', '.*'|'SALT', '${SALT}'|g" ./config.py
  fi

fi


log "===> Database management"
if [ ! -f "${DB_MIGRATION_DIR}/README" ]; then

  log "---> Running DB Migration"
  set +e
  flask db upgrade --directory ${DB_MIGRATION_DIR}
  set -e

  log "---> Initializing settings"
  ./init_setting.py

  log "---> Initializing admin user"
  ./init_admin.py

else

  log "---> Running DB Upgrade"
  set +e
  flask db upgrade --directory ${DB_MIGRATION_DIR}
  set -e

fi

#echo "===> (TODO) Update PDNS API connection info"


log "===> Assets management"
log "---> Running Yarn"
yarn install --pure-lockfile
# Fix for https://github.com/ngoduykhanh/PowerDNS-Admin/issues/310
ln -sf "$(pwd)/node_modules" ./app/static/node_modules

log "---> Running Flask assets"
flask assets build


log "===> Start gunicorn server"
GUNICORN_TIMEOUT="${GUINCORN_TIMEOUT:-120}"
GUNICORN_WORKERS="${GUNICORN_WORKERS:-4}"
GUNICORN_LOGLEVEL="${GUNICORN_LOGLEVEL:-info}"

GUNICORN_ARGS="-t ${GUNICORN_TIMEOUT} --workers ${GUNICORN_WORKERS} --bind ${BIND_ADDRESS}:${PORT} --log-level ${GUNICORN_LOGLEVEL}"

if [ -n  "${GUNICORN_CERTFILE}" ]; then
  GUNICORN_ARGS="${GUNICORN_ARGS} --certfile=${GUNICORN_CERTFILE}"
fi

if [ -n  "${GUNICORN_KEYFILE}" ]; then
  GUNICORN_ARGS="${GUNICORN_ARGS} --keyfile=${GUNICORN_KEYFILE}"
fi

if [ "$1" == "gunicorn" ]; then
    exec "$@" $GUNICORN_ARGS
else
    exec "$@"
fi
