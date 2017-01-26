require 'charmkit'
use :nginx
use :php

namespace :dokuwiki do

  desc "Install Dokuwiki"
  task :install do
    deps.install

    app_path = config 'app_path'
    resource_path = resource 'stable-release'
    hook_path = ENV['JUJU_CHARM_DIR']

    mkdir_p app_path

    run "tar", "xf", resource_path, "-C", app_path, "--strip-components=1"

    cp "#{hook_path}/templates/acl.auth.php", "#{app_path}/conf/acl.auth.php"
    cp "#{hook_path}/templates/local.php", "#{app_path}/conf/local.php"
    cp "#{hook_path}/templates/plugins.local.php", "#{app_path}/conf/plugin.local.php"

    version = File.read "#{app_path}/VERSION"
    run "application-version-set", version.chomp
    status :active, "Dokuwiki installed, please set your admin user and password with juju config dokuwiki admin_user=<an_admin_name> admin_password=<sha512 password>"
  end

  desc "Configure Dokuwiki"
  task :config_changed do
    app_path = config 'app_path'
    hook_path = ENV['JUJU_CHARM_DIR']

    admin_user = config 'admin_user'
    admin_password = config 'admin_password'
    admin_name = config 'admin_name'
    admin_email = config 'admin_email'
    template "#{hook_path}/templates/users.auth.php",
             "#{app_path}/conf/users.auth.php",
             admin_user: admin_user,
             admin_password: admin_password,
             admin_name: admin_name,
             admin_email: admin_email

    public_address = unit 'public-address'
    template "#{hook_path}/templates/vhost.conf",
             "/etc/nginx/sites-enabled/default",
             public_address: public_address,
             app_path: app_path

    chown_R 'www-data', 'www-data', app_path

    run "systemctl restart php7.0-fpm"
    run "systemctl restart nginx"
    run "open-port 80"
    status :active, "Dokuwiki updated and is now ready."
  end
end

task :default => 'dokuwiki:install'
