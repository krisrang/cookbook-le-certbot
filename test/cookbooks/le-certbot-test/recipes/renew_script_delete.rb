certbot_renew_script 'testscript' do
  contents 'reload command'
  action :delete
end
