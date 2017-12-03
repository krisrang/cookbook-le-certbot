resource_name :certbot

action :install do
  apt_repository 'certbot' do
    uri          'ppa:certbot/certbot'
    distribution node['lsb']['codename']
  end

  package 'certbot' do
    action :install
  end

  cron 'certbot renew scripts' do
    action :delete
  end
end

action :remove do
  apt_repository 'certbot' do
    uri          'ppa:certbot/certbot'
    distribution node['lsb']['codename']
    action :remove
  end

  package 'certbot' do
    action :remove
  end

  directory node['certbot']['renew_scripts_root'] do
    recursive true
    action :delete
  end

  cron 'certbot renew scripts' do
    action :delete
  end
end

action_class do
  include Certbot::Helper
end
