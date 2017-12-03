name              'le-certbot'
maintainer        'Kristjan Rang'
maintainer_email  'mail@rang.ee'
license           'MIT'
description       'Manages certbot installation, Let\'s Encrypt certificates, and certbot renew scripts'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.3.0'

supports 'ubuntu'

issues_url 'https://github.com/krisrang/certbot/issues'
source_url 'https://github.com/krisrang/certbot'
chef_version '>= 12.9' if respond_to?(:chef_version)
