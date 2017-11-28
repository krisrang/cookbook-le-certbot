module Certbot
  module Helper
    def certbot_certificates_dir(domain)
      ::File.join("", "etc", "letsencrypt", "live", domain)
    end

    def certbot_cert_path_for(domain)
      ::File.join(certbot_certificates_dir(domain), "cert.pem")
    end

    def certbot_chain_path_for(domain)
      ::File.join(certbot_certificates_dir(domain), "chain.pem")
    end

    def certbot_fullchain_path_for(domain)
      ::File.join(certbot_certificates_dir(domain), "fullchain.pem")
    end

    def certbot_privatekey_path_for(domain)
      ::File.join(certbot_certificates_dir(domain), "privkey.pem")
    end

    def certbot_webroot_path
      node["certbot"]["webroot"]
    end

    def certbot_well_known_path
      ::File.join(certbot_webroot_path, ".well-known")
    end

    def certbot_executable
      "/usr/bin/certbot"
    end

    def base_command
      "#{certbot_executable} certonly --non-interactive"
    end

    def domain_arg
      "--domain #{new_resource.domain}"
    end

    def webroot_arg
      "--webroot -w #{certbot_webroot_path}"
    end

    def renew_arg
      case new_resource.renew_policy
      when :force then "--renew-by-default"
      when :keep then "--keep-until-expiring"
      end
    end

    def test_arg
      "--test-cert" if new_resource.test
    end

    def rsa_size_arg
      "--rsa-key-size #{node['certbot']['rsa_key_size']}"
    end
  end
end
