# le-certbot Cookbook CHANGELOG

This file is used to list changes made in each version of the le-certbot cookbook.

## 0.4.0 (2017-12-05)

### Breaking changes

`certbot_certificate` no longer dynamically sets node attributes with certificate locations. Use `node['le-certbot']['live_path']` to find the certificates. Check the README.

## 0.3.1 (2017-12-03)

- Updated `default` recipe to include latest API changes.

## 0.3.0 (2017-12-03)

### Breaking changes

Found out certbot installs renew hook cron and paths itself so use that instead and dump all cron management.

### Other Changes

- Fixed dokken ubuntu 16.04 test run.

## 0.2.0 (2017-12-02)

### Breaking changes

Refactored all resources - some properties were changed. Removed the certbot_link resource.

### Other Changes

- Added tests and set up Travis CI.
