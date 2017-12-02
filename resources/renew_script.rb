resource_name :certbot_renew_script

property :filename, String, name_property: true
property :contents, String
property :cookbook, String, default: 'le-certbot'

action :install do
  directory renew_scripts_path do
    owner 'root'
    group 'root'
    mode 0755
    recursive true
  end

  template renew_script_path(new_resource.filename) do
    cookbook new_resource.cookbook
    source 'script.sh.erb'
    variables(
      contents: new_resource.contents
    )
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

action :delete do
  template renew_script_path(new_resource.filename) do
    cookbook new_resource.cookbook
    source 'script.sh.erb'
    action :delete
  end
end

action_class do
  include Certbot::Helper
end
