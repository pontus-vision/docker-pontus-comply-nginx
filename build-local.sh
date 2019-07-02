#!/bin/bash
set -e 
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
docker build --no-cache --rm . -t pontusvisiongdpr/pontus-comply-nginx-lgpd
docker push pontusvisiongdpr/pontus-comply-nginx-lgpd


