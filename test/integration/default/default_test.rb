describe apt('ppa:certbot/certbot') do
  it { should exist }
  it { should be_enabled }
end

describe package('certbot') do
  it { should be_installed }
end

describe directory('/etc/letsencrypt') do
  it { should exist }
  it { should be_directory }
end

describe file('/usr/bin/certbot') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }
  it { should be_executable }
end

describe directory('/etc/letsencrypt/renewal-hooks/post') do
  it { should exist }
  it { should be_directory }
end
