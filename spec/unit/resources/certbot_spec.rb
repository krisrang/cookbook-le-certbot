require 'spec_helper'

describe 'certbot' do
  context 'with cron' do
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

    it 'creates renew directories and scripts' do
      expect(chef_run).to create_template('/var/lib/letsencryptrenew/renew.sh').with(
        variables: {
          root: '/var/lib/letsencryptrenew/scripts',
        }
      )

      expect(chef_run).to create_directory('/var/lib/letsencryptrenew/scripts')
    end

    it 'creates renew cron' do
      expect(chef_run).to create_cron('certbot renew script').with(
        time: :weekly,
        command: %r{certbot renew --post-hook '/var/lib/letsencryptrenew/renew.sh' > /var/log/certbot.log}
      )
    end
  end

  context 'without cron' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot']).converge('le-certbot-test::certbot_no_cron')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs certbot' do
      expect(chef_run).to install_package('certbot')
    end

    it 'skips renew directories and scripts' do
      expect(chef_run).to_not create_template('/var/lib/letsencryptrenew/renew.sh')
      expect(chef_run).to_not create_directory('/var/lib/letsencryptrenew/scripts')
    end

    it 'skips renew cron' do
      expect(chef_run).to_not create_cron('certbot renew script')
    end
  end
end
