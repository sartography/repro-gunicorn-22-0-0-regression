#!/usr/bin/env bash

function error_handler() {
  echo >&2 "Exited with BAD EXIT CODE '${2}' in ${0} script at line: ${1}."
  exit "$2"
}
trap 'error_handler ${LINENO} $?' ERR
set -o errtrace -o errexit -o nounset -o pipefail

container_name=gunicornbrokenouchycontainer
if [[ -n "$(docker ps -a -q -f name=${container_name})" ]]; then
  docker rm -f "$container_name"
fi

docker build . -t gunicornbrokenouchy
docker run -d --name "$container_name" -p 8000:8000 gunicornbrokenouchy
sleep 4
curl -H "SCRIPT_NAME: /api" http://localhost:8000/api/hello
