module Certbot
  module Helper
    def live_path(domain)
      ::File.join(node['le-certbot']['live_path'], domain)
    end

    def cert_path(domain)
      ::File.join(live_path(domain), 'cert.pem')
    end

    def chain_path(domain)
      ::File.join(live_path(domain), 'chain.pem')
    end

    def fullchain_path(domain)
      ::File.join(live_path(domain), 'fullchain.pem')
    end

    def key_path(domain)
      ::File.join(live_path(domain), 'privkey.pem')
    end

    def webroot_path
      node['le-certbot']['webroot']
    end

    def well_known_path
      ::File.join(webroot_path, '.well-known')
    end

    def renew_scripts_path
      node['le-certbot']['renew_scripts_root']
    end

    def renew_script_path(name)
      ::File.join(node['le-certbot']['renew_scripts_root'], name)
    end

    def certbot_executable
      node['le-certbot']['executable_path']
    end

    def certbot_command
      "#{certbot_executable} certonly --non-interactive"
    end

    def create_cert_command
      cmd = [certbot_command]
      cmd.push("-webroot -w #{webroot_path}")

      ([new_resource.domain] + new_resource.domains).each do |domain|
        cmd.push("--domain #{domain}")
      end

      renew = case new_resource.renew_policy
              when :force then '--renew-by-default'
              when :keep then '--keep-until-expiring'
              end

      cmd.push(renew)
      cmd.push(test_arg)
      cmd.push("--rsa-key-size #{node['le-certbot']['rsa_key_size']}")

      cmd.join(' ')
    end

    def test_arg
      '--test-cert' if new_resource.test
    end
  end
end
