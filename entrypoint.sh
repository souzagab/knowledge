#!/bin/bash

set -e

rm -f "${APP_PATH}/tmp/pids/server.pid"

exec "$@"
