default['le-certbot']['rsa_key_size'] = 4096
default['le-certbot']['webroot'] = '/var/www'

# platform specific
default['le-certbot']['executable_path'] = '/usr/bin/certbot'
default['le-certbot']['live_path'] = '/etc/letsencrypt/live'
default['le-certbot']['renew_scripts_root'] = '/etc/letsencrypt/renewal-hooks/post'
