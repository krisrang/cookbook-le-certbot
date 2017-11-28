resource_name :certbot

property :install_cron, [true, false], default: true
property :frequency, Symbol, default: :daily, equal_to: [:daily, :weekly, :monthly]

action :install do
  apt_repository "certbot" do
    uri          "ppa:certbot/certbot"
    distribution node["lsb"]["codename"]
  end

  package "certbot" do
    action :install
  end

  renew_command = "#{certbot_executable} renew --post-hook \"#{node["certbot"]["cron_scripts_path"]}/renew.sh\" > #{node["certbot"]["cron_log"]} 2>&1"

  directory "#{node["certbot"]["cron_scripts_path"]}/scripts" do
    owner "root"
    group "root"
    mode 0755
    recursive true

    only_if { new_resource.install_cron }
  end

  template "#{node["certbot"]["cron_scripts_path"]}/renew.sh" do
    cookbook "certbot-cron"
    source "renew.sh.erb"
    variables(
      root: "#{node["certbot"]["cron_scripts_path"]}/scripts"
    )
    owner "root"
    group "root"
    mode "0755"
    action :create

    only_if { new_resource.install_cron }
  end

  cron "certbot renew scripts" do
    time new_resource.frequency
    user "root"
    command renew_command
    action :create

    only_if { new_resource.install_cron }
  end
end

action :remove do
  apt_repository "certbot" do
    uri          "ppa:certbot/certbot"
    distribution node["lsb"]["codename"]
    action :remove
  end

  package "certbot" do
    action :remove
  end

  directory node["certbot"]["cron_scripts_path"] do
    recursive true
    action :delete
  end

  cron "certbot renew scripts" do
    action :delete
  end
end

action_class do
  include Certbot::Helper
end
