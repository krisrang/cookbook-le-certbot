resource_name :certbot_certificate

property :domain, String, name_property: true
property :email, String
property :renew_policy, Symbol, default: :keep, equal_to: [:keep, :force]
property :allow_fail, [true, false], default: false
property :test, [true, false], default: false

action :create do
  directory certbot_webroot_path do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  cert_command = "#{base_command} #{domain_arg} #{webroot_arg} #{renew_arg} #{test_arg} #{rsa_size_arg}"

  certificate_request = "#{cert_command} --email #{new_resource.email} --agree-tos"
  if new_resource.allow_fail
    certificate_request << " || true"
  end

  execute "certbot create certificate" do
    command certificate_request
  end
end

action :delete do
  cert_command = "#{base_command} delete --cert-name #{new_resource.domain}"

  if new_resource.allow_fail
    cert_command << " || true"
  end

  execute "certbot delete certificate" do
    command cert_command
  end
end

action :revoke do
  cert_command = "#{base_command} revoke ---cert-path #{certbot_fullchain_path_for(new_resource.domain)} #{test_arg}"

  if new_resource.allow_fail
    cert_command << " || true"
  end

  execute "certbot revoke certificate" do
    command cert_command
  end
end

action_class do
  include Certbot::Helper
end
