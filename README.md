# le-certbot Cookbook

[![Build Status](https://travis-ci.org/krisrang/certbot.svg?branch=master)](https://travis-ci.org/krisrang/certbot) [![Cookbook Version](https://img.shields.io/cookbook/v/le-certbot.svg)](https://supermarket.chef.io/cookbooks/le-certbot)

This cookbook is used to configure a system as a Chef Client.

## Requirements

### Platforms

- Ubuntu

### Chef

- Chef 12.9+

### Dependent Cookbooks

- none

## Attributes

The following attributes affect the behavior of the chef-client program when running as a service through one of the service recipes, or in cron with the cron recipe, or are used in the recipes for various settings that require flexibility.

- `node['le-certbot']['rsa_key_size']` - Sets RSA key size for certificates requested with `certbot_certificate`. Default 4096.
- `node['le-certbot']['webroot']` - Sets the webroot when requesting certificate with `certbot_certificate`. Default "/var/www".
- `node['le-certbot']['certificates']` - Hash of locations certbot has installed certificates to on the node.

The following attributes are set on a per-platform basis, see the `attributes/default.rb` file for default values.

- `node['le-certbot']['renew_scripts_root']` - Sets the directory where certbot expects renew scripts to be installed to.
- `node['le-certbot']['executable_path']` - Sets the default location of the `certbot` executable on the node.
- `node['le-certbot']['live_path']` - Sets the default location certbot links live certificates to on the node.

## Recipes

This section describes the recipes in the cookbook and how to use them in your environment.

### default

Sets up certbot on the node.

## Usage

Use the recipes as described above to configure your systems to run Chef as a service via cron / scheduled task or one of the service management systems supported by the recipes.

## Resources

### certbot

The certbot resource installs certbot.

### Actions

- `:install`
- `:remove`

### Properties

- none

### certbot_certificate

The certbot_certificate manages Let's Encrypt certificates via certbot.

### Actions

- `:create`
- `:delete` - deletes the certificate from the node
- `:revoke` - revokes the certificate but does not delete it

### Properties

- `domain` - Domain for the certificate.
- `email` - Let's Encrypt account email.
- `renew_policy` - Specifies whether when requesting certificate via certbot and a valid active certificate to keep it or force request a new one ('keep', 'force'). Default is 'keep'
- `test` - Connect to Let's Encrypt staging servers instead of live. Default is 'false'

### certbot_renew_script

The certbot\_renew_script manages certificate renew hook scripts that run when any certificates have been updated.

### Actions

- `:install`
- `:delete`

### Properties

- `contents` - Contents of the script. The script is run via bash so most any commands are accepted.
- `cookbook` - Cookbook to look for the `script.sh.erb` template that wraps the script if for example you want to use a different shebang. Default is 'le-certbot'

## License

**Copyright:** (c) 2017 Kristjan Rang

```
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
