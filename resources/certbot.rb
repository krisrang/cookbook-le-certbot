resource_name :certbot

action :install do
  if platform?('ubuntu')
    apt_repository 'certbot' do
      uri          'ppa:certbot/certbot'
      distribution node['lsb']['codename']
    end

    package 'certbot' do
      action :install
    end
  elsif platform?('debian')
    package 'certbot' do
      default_release "#{node['lsb']['codename']}-backports"
      action :install
    end
  end
end

action :remove do
  if platform?('ubuntu')
    apt_repository 'certbot' do
      uri          'ppa:certbot/certbot'
      distribution node['lsb']['codename']
      action :remove
    end
  end

  package 'certbot' do
    action :remove
  end

  directory node['certbot']['renew_scripts_root'] do
    recursive true
    action :delete
  end
end

action_class do
  include Certbot::Helper
end
