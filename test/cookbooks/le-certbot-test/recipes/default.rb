include_recipe 'cron'

directory "#{node['le-certbot']['live_path']}/test.domain.com" do
  recursive true
end

file "#{node['le-certbot']['live_path']}/test.domain.com/fullchain.pem" do
  content 'fullchain'
end

include_recipe 'le-certbot-test::certbot'
include_recipe 'le-certbot-test::certificate'
include_recipe 'le-certbot-test::renew_script'
