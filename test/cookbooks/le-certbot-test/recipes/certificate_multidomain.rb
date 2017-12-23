certbot_certificate 'test.domain.com' do
  domains ['other.domain.com', 'and.domain.com']
  email 'mail@rang.ee'
  test true
end
