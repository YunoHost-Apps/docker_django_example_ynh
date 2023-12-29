#!/bin/sh

set -ex

./wait_for_services.py

./manage.py collectstatic
./manage.py migrate

gunicorn --config gunicorn.conf.py wsgi
