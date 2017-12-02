require 'spec_helper'

describe 'certbot_renew_script' do
  context 'install' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_renew_script']).converge('le-certbot-test::renew_script')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates scripts path' do
      expect(chef_run).to create_directory('/var/lib/letsencryptrenew/scripts').with(
        recursive: true
      )
    end

    it 'creates script' do
      expect(chef_run).to create_template('/var/lib/letsencryptrenew/scripts/testscript').with(
        owner: 'root',
        mode: '0755'
      )
    end
  end

  context 'delete' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_renew_script']).converge('le-certbot-test::renew_script_delete')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'deletes the script' do
      expect(chef_run).to delete_template('/var/lib/letsencryptrenew/scripts/testscript')
    end
  end
end
