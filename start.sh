#!/bin/bash
#
# Entrypoint script for Zenphoto CMS Docker
#
# Assumes that user will provide database information
# as environment variables:
# - MARIADB_USER
# - MARIADB_PASSWORD
# - MARIADB_HOST
# - MARIADB_DATABASE
#

set -e
set -u
set -o pipefail
#set -x

cfg_file="zp-data/zenphoto.cfg.php"

set_config_field()
{
	name="${1}"
	value="${2}"

	sed -i \
		"s/^\(\$conf\['${name}'\] =\) .*/\1 '${value}';/" \
		"${cfg_file}"
}


generate_config_file()
{
	cp \
		"zp-core/file-templates/zenphoto_cfg.txt" \
		"${cfg_file}"

	set_config_field 'mysql_user' "${MARIADB_USER}"
	set_config_field 'mysql_pass' "${MARIADB_PASSWORD}"
	set_config_field 'mysql_host' "${MARIADB_HOST}"
	set_config_field 'mysql_database' "${MARIADB_DATABASE}"
}

if ! [ -f "/var/www/html/zenphoto/start-ok.txt" ]; then
	cd /var/www/html
	unzip -q /zenphoto.zip
	mv zenphoto-* zenphoto

	cd zenphoto

	touch zp-data/setup.log
	touch zp-data/charset_tést
	generate_config_file

	chown -R www-data:www-data .
	chmod 0644 `find -type f`
	chmod 0755 `find -type d`
	chmod 0500 zp-core
	chmod 0600 zp-data/*

	touch start-ok.txt
fi

umask 0077
exec "$@"
