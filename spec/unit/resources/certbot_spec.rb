require 'spec_helper'

describe 'certbot' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot']).converge('le-certbot-test::certbot')
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'installs certbot' do
    expect(chef_run).to add_apt_repository('certbot').with(
      uri: 'ppa:certbot/certbot',
      distribution: 'xenial'
    )

    expect(chef_run).to install_package('certbot')
  end
end
