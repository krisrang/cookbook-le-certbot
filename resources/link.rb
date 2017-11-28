resource_name :certbot_link

property :domain, String, name_property: true
property :fullchain_path, String
property :key_path, String

action :install do
  link certbot_fullchain_path_for(new_resource.domain) do
    to new_resource.fullchain_path
  end

  link certbot_privatekey_path_for(new_resource.domain) do
    to new_resource.key_path
  end
end

action_class do
  include Certbot::Helper
end
