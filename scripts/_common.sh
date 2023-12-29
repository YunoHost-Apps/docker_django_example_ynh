#!/bin/bash

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST
#=================================================

# Transfer the main SSO domain to the App:
ynh_current_host=$(cat /etc/yunohost/current_host)
__YNH_CURRENT_HOST__=${ynh_current_host}

#=================================================
# ARGUMENTS FROM CONFIG PANEL
#=================================================

# 'debug_enabled' -> '__DEBUG_ENABLED__' -> settings.DEBUG
debug_enabled="0" # "1" or "0" string

# 'log_level' -> '__LOG_LEVEL__' -> settings.LOG_LEVEL
log_level="WARNING"

# 'admin_email' -> '__ADMIN_EMAIL__' add in settings.ADMINS
admin_email="${admin}@${domain}"

# 'default_from_email' -> '__DEFAULT_FROM_EMAIL__' -> settings.DEFAULT_FROM_EMAIL
default_from_email="${app}@${domain}"

#=================================================
# HELPERS
#=================================================

myynh_add_conf_files() {
    (
        set -x

        # "ynh_add_config" statements generated by list-ynh-add-config.py:
        ynh_add_config --template=".dockerignore" --destination="$data_dir/.dockerignore"
        ynh_add_config --template="Dockerfile" --destination="$data_dir/Dockerfile"
        ynh_add_config --template="Makefile" --destination="$data_dir/Makefile"
        ynh_add_config --template="app-entrypoint.sh" --destination="$data_dir/app-entrypoint.sh"
        ynh_add_config --template="common.env" --destination="$data_dir/common.env"
        ynh_add_config --template="compose.sh" --destination="$data_dir/compose.sh"
        ynh_add_config --template="django-settings.py" --destination="$data_dir/django-settings.py"
        ynh_add_config --template="docker-compose.yml" --destination="$data_dir/docker-compose.yml"
        ynh_add_config --template="gunicorn.conf.py" --destination="$data_dir/gunicorn.conf.py"
        ynh_add_config --template="manage.py" --destination="$data_dir/manage.py"
        ynh_add_config --template="nginx.conf" --destination="$data_dir/nginx.conf"
        ynh_add_config --template="requirements.txt" --destination="$data_dir/requirements.txt"
        ynh_add_config --template="systemd.service" --destination="$data_dir/systemd.service"
        ynh_add_config --template="wait_for_services.py" --destination="$data_dir/wait_for_services.py"
        ynh_add_config --template="wsgi.py" --destination="$data_dir/wsgi.py"
    )
}

myynh_fix_file_permissions() {
    (
        set -x

        # /var/www/$app/
        chown -c -R "$app:www-data" "$install_dir"
        chmod -c o-rwx "$install_dir"

        # /home/yunohost.app/$app/
        chown -c -R "$app:" "$data_dir"
        chmod -c o-rwx "$data_dir"

        chmod -c +x $data_dir/app-entrypoint.sh
        chmod -c +x $data_dir/compose.sh
        chmod -c +x $data_dir/manage.py
        chmod -c +x $data_dir/wait_for_services.py
    )
}

myynh_setup_docker() {
    (
        set -x

        # Add the app system user to "docker" user group:
        usermod -aG docker $app

        cd "$data_dir/"
        make build
    )
}
