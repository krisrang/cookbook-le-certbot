resource_name :certbot_renew_script

property :name, String, name_property: true
property :contents, String

action :install do
  directory "#{node["certbot"]["cron_scripts_path"]}/scripts" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  template "#{node["certbot"]["cron_scripts_path"]}/scripts/#{new_resource.name}" do
    cookbook "certbot"
    source "script.sh.erb"
    variables(
      contents: new_resource.contents
    )
    owner "root"
    group "root"
    mode "0755"
    backup false
    action :create
  end
end

action :delete do
  template "#{node["certbot"]["cron_scripts_path"]}/scripts/#{new_resource.name}" do
    cookbook "certbot"
    source "script.sh.erb"
    action :delete
  end
end
