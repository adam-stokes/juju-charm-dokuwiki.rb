require 'charmkit'
require 'charmkit/plugins/nginx'
require 'charmkit/plugins/php'

namespace :dokuwiki do

  desc "Install Dokuwiki"
  task :install => ["nginx:install", "php:install"] do
    app_path = cmd.run('config-get', 'app_path').out.chomp
    resource_path = cmd.run('resource-get', 'stable-release').out.chomp
    hook_path = ENV['JUJU_CHARM_DIR']

    mkdir_p app_path unless Dir.exists? app_path

    cmd.run "tar", "xf", resource_path, "-C", app_path, "--strip-components=1"

    cp "#{hook_path}/templates/acl.auth.php", "#{app_path}/conf/acl.auth.php"
    cp "#{hook_path}/templates/local.php", "#{app_path}/conf/local.php"
    cp "#{hook_path}/templates/plugins.local.php", "#{app_path}/conf/plugin.local.php"

    version = File.read "#{app_path}/VERSION"
    cmd.run "application-version-set", version.chomp
    cmd.run "status-set", "active", "Dokuwiki installed, please set your admin user and password with juju config dokuwiki admin_user=<an_admin_name> admin_password=<sha512 password>"
  end

  desc "Configure Dokuwiki"
  task :config_changed do
    app_path = cmd.run('config-get', 'app_path').out.chomp
    hook_path = ENV['JUJU_CHARM_DIR']

    admin_user = cmd.run('config-get', 'admin_user').out.chomp
    admin_password = cmd.run('config-get', 'admin_password').out.chomp
    admin_name = cmd.run('config-get', 'admin_name').out.chomp
    admin_email = cmd.run('config-get', 'admin_email').out.chomp
    template "#{hook_path}/templates/users.auth.php",
             "#{app_path}/conf/users.auth.php",
             admin_user: admin_user,
             admin_password: admin_password,
             admin_name: admin_name,
             admin_email: admin_email

    public_address = cmd.run('unit-get', 'public-address').out.chomp
    template "#{hook_path}/templates/vhost.conf",
             "/etc/nginx/sites-enabled/default",
             public_address: public_address,
             app_path: app_path

    chown_R 'www-data', 'www-data', app_path

    cmd.run "systemctl", "restart", "php7.0-fpm"
    cmd.run "systemctl", "restart", "nginx"
    cmd.run "status-set", "active", "Dokuwiki updated and is now ready."
  end
end

task :default => 'dokuwiki:install'
