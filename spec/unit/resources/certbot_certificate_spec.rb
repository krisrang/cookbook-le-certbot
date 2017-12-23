require 'spec_helper'

describe 'certbot_certificate' do
  context 'create' do
    context 'with no existing certificate' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_certificate']).converge('le-certbot-test::certificate')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'creates webroot' do
        expect(chef_run).to create_directory('/var/www').with(
          recursive: true
        )
      end

      it 'executes certbot' do
        expect(chef_run).to run_execute('certbot create certificate').with(
          command: /certbot certonly --non-interactive --domain test.domain.com/
        )
      end
    end

    context 'with existing certificate' do
      let(:chef_run) do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with('/etc/letsencrypt/live/test.domain.com/fullchain.pem').and_return(true)
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_certificate']).converge('le-certbot-test::certificate')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'creates webroot' do
        expect(chef_run).to create_directory('/var/www').with(
          recursive: true
        )
      end

      it 'does not execute certbot' do
        expect(chef_run).to_not run_execute('certbot create certificate')
      end
    end
  end

  context 'create with multiple domains' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_certificate']).converge('le-certbot-test::certificate_multidomain')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'executes certbot' do
      expect(chef_run).to run_execute('certbot create certificate').with(
        command: /certbot certonly --non-interactive --domain test.domain.com --domain other.domain.com --domain and.domain.com/
      )
    end
  end

  context 'delete' do
    context 'with no existing certificate' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_certificate']).converge('le-certbot-test::certificate_delete')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'does not delete certificate' do
        expect(chef_run).to_not run_execute('certbot delete certificate')
      end
    end

    context 'with existing certificate' do
      let(:chef_run) do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with('/etc/letsencrypt/live/test.domain.com/fullchain.pem').and_return(true)
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_certificate']).converge('le-certbot-test::certificate_delete')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'deletes certificate' do
        expect(chef_run).to run_execute('certbot delete certificate').with(
          command: /certbot certonly --non-interactive delete --cert-name test.domain.com/
        )
      end
    end
  end

  context 'revoke' do
    context 'with no existing certificate' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_certificate']).converge('le-certbot-test::certificate_revoke')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
    end

    context 'with existing certificate' do
      let(:chef_run) do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with('/etc/letsencrypt/live/test.domain.com/fullchain.pem').and_return(true)
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['certbot_certificate']).converge('le-certbot-test::certificate_revoke')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'revokes certificate' do
        expect(chef_run).to run_execute('certbot revoke certificate').with(
          command: /certbot certonly --non-interactive revoke ---cert-path.*test.domain.com/
        )
      end
    end
  end
end
