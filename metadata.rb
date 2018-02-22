name              'le-certbot'
maintainer        'Kristjan Rang'
maintainer_email  'mail@rang.ee'
license           'MIT'
description       'Manages certbot installation, Let\'s Encrypt certificates, and certbot renew scripts'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.7.0'

supports 'ubuntu'
supports 'debian'

issues_url 'https://github.com/krisrang/cookbook-le-certbot/issues'
source_url 'https://github.com/krisrang/cookbook-le-certbot'
chef_version '>= 12.9' if respond_to?(:chef_version)
