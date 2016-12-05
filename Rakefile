require 'charmkit'
require 'charmkit/plugins/nginx'
require 'charmkit/plugins/php'

namespace :dokuwiki do

  desc "Install Dokuwiki"
  task :install => ["nginx:install", "php:install"] do
    app_path = `config-get app_path`.chomp
    resource_path = `resource-get stable-release`.chomp
    hook_path = ENV['JUJU_CHARM_DIR']

    mkdir_p app_path unless Dir.exists? app_path

    `tar xf #{resource_path} -C #{app_path} --strip-components=1`
    cp "#{hook_path}/templates/acl.auth.php", "#{app_path}/conf/acl.auth.php"
    cp "#{hook_path}/templates/local.php", "#{app_path}/conf/local.php"
    cp "#{hook_path}/templates/plugins.local.php", "#{app_path}/conf/plugin.local.php"

    version = File.read "#{app_path}/VERSION"
    `application-version-set '#{version}'`
    `status-set active "Dokuwiki Install finished."`
  end

  desc "Configure Dokuwiki"
  task :config_changed do
    app_path = `config-get app_path`.chomp
    hook_path = ENV['JUJU_CHARM_DIR']

    admin_user = `config-get admin_user`.chomp
    admin_password = `config-get admin_password`.chomp
    admin_name = `config-get admin_name`.chomp
    admin_email = `config-get admin_email`.chomp
    template "#{hook_path}/templates/users.auth.php",
             "#{app_path}/conf/users.auth.php",
             admin_user: admin_user,
             admin_password: admin_password,
             admin_name: admin_name,
             admin_email: admin_email

    public_address = `unit-get public-address`.chomp
    template "#{hook_path}/templates/vhost.conf",
             "/etc/nginx/sites-enabled/default",
             public_address: public_address,
             app_path: app_path

    chown_R 'www-data', 'www-data', app_path

    `systemctl restart php7.0-fpm`
    `systemctl restart nginx`
    `status-set active "Ready"`
  end
end

task :default => 'dokuwiki:install'
