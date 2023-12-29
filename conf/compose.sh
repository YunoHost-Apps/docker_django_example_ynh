#!/bin/bash

source common.env

set -ex

# Used in docker-compose.yml:
CURRENT_UID="$(id -u)"
export CURRENT_UID

CURRENT_GID="$(id -g)"
export CURRENT_GID

# Compose v2 is always accessible as docker compose!
# But Debian bullseye contains v1
exec docker-compose "$@"
