#!/bin/bash
#
# Entrypoint script for Zenphoto Docker
#
# Requires the following environment variables:
# - MARIADB_USER
# - MARIADB_PASSWORD
# - MARIADB_DATABASE
# - DB_HOST
#

set -e
set -u
set -o pipefail

# Validate required environment variables early
for var in MARIADB_USER MARIADB_PASSWORD DB_HOST MARIADB_DATABASE; do
	if [ -z "${!var:-}" ]; then
		echo "ERROR: Required environment variable '$var' is not set." >&2
		exit 1
	fi
done

cfg_file="zp-data/zenphoto.cfg.php"

# Escape a string for safe use as a sed replacement value
sed_escape() {
	printf '%s' "$1" | sed 's/[\/&]/\\&/g; s/$/\\n/' | tr -d '\n' | sed 's/\\n$//'
}

set_config_field()
{
	local name="${1}"
	local value
	value=$(sed_escape "${2}")

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
	set_config_field 'mysql_host' "${DB_HOST}"
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
	find . -type f -exec chmod 0644 {} +
	find . -type d -exec chmod 0755 {} +
	chmod 0500 zp-core
	chmod 0600 zp-data/*

	touch start-ok.txt
fi

umask 0077
exec "$@"
