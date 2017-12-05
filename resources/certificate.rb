resource_name :certbot_certificate

property :domain, String, name_property: true
property :email, String, default: ''
property :renew_policy, Symbol, default: :keep, equal_to: [:keep, :force]
property :allow_fail, [true, false], default: false
property :test, [true, false], default: false

action :create do
  directory webroot_path do
    owner 'root'
    group 'root'
    mode 0755
    recursive true
  end

  cert_command = "#{create_cert_command} --email #{new_resource.email} --agree-tos"
  cert_command << ' || true' if new_resource.allow_fail

  execute 'certbot create certificate' do
    command cert_command

    not_if { ::File.exist?(fullchain_path(new_resource.domain)) }
  end
end

action :delete do
  cert_command = "#{certbot_command} delete --cert-name #{new_resource.domain}"
  cert_command << ' || true' if new_resource.allow_fail

  execute 'certbot delete certificate' do
    command cert_command

    only_if { ::File.exist?(fullchain_path(new_resource.domain)) }
  end
end

action :revoke do
  cert_command = "#{certbot_command} revoke ---cert-path #{fullchain_path(new_resource.domain)} #{test_arg}"
  cert_command << ' || true' if new_resource.allow_fail

  execute 'certbot revoke certificate' do
    command cert_command

    only_if { ::File.exist?(fullchain_path(new_resource.domain)) }
  end
end

action_class do
  include Certbot::Helper
end
