resource_name :certbot

property :renew, [true, false], default: true
property :frequency, Symbol, default: :weekly, equal_to: [:none, :daily, :weekly, :monthly]
property :cookbook, String, default: 'le-certbot'

action :install do
  apt_repository 'certbot' do
    uri          'ppa:certbot/certbot'
    distribution node['lsb']['codename']
  end

  package 'certbot' do
    action :install
  end

  renew_command = "#{certbot_executable} renew --post-hook '#{renew_hook}' > #{node['le-certbot']['renew_log']} 2>&1"

  directory renew_scripts_path do
    owner 'root'
    group 'root'
    mode 0755
    recursive true

    only_if { new_resource.renew }
  end

  template renew_hook do
    cookbook new_resource.cookbook
    source 'renew.sh.erb'
    variables(
      root: renew_scripts_path
    )
    owner 'root'
    group 'root'
    mode '0755'
    action :create

    only_if { new_resource.renew }
  end

  cron 'certbot renew script' do
    time new_resource.frequency
    user 'root'
    command renew_command
    action :create

    only_if { new_resource.renew }
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
