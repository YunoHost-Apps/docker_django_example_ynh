# https://hub.docker.com/_/python
FROM python:3.11-slim-bookworm

# Install "libpq-dev" to install "pg_config" needed by "psycopg2"
# We didn't use "psycopg2-binary": It's not available on ARM boards, e.g.:
# https://github.com/jedie/PyInventory/issues/56

RUN set -x \
    && apt update \
    && apt install -y libpq-dev python3-pip \
    && apt full-upgrade -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt

WORKDIR /app

COPY requirements.txt .

ENV PYTHONUNBUFFERED=1

RUN set -x \
    && python3 -m pip install -U pip \
    && pip install --no-cache -r requirements.txt

# Needed files to startup the Django App:
COPY app-entrypoint.sh .
COPY django-settings.py .
COPY gunicorn.conf.py .
COPY wait_for_services.py .
COPY wsgi.py .

# Usefull for debugging:
COPY manage.py .
